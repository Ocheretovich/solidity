/*
	This file is part of solidity.

	solidity is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	solidity is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with solidity.  If not, see <http://www.gnu.org/licenses/>.
*/
// SPDX-License-Identifier: GPL-3.0

#include <libyul/ObjectCache.h>

#include <libyul/AsmPrinter.h>
#include <libyul/AST.h>
#include <libyul/Exceptions.h>
#include <libyul/backends/evm/EVMDialect.h>
#include <libyul/backends/evm/EVMMetrics.h>
#include <libyul/optimiser/ASTCopier.h>
#include <libyul/optimiser/Suite.h>

#include <liblangutil/DebugInfoSelection.h>

#include <libsolutil/Keccak256.h>

#include <boost/algorithm/string.hpp>

#include <numeric>

using namespace solidity;
using namespace solidity::langutil;
using namespace solidity::util;
using namespace solidity::yul;


Dialect const& yul::languageToDialect(Language _language, EVMVersion _version)
{
	switch (_language)
	{
	case Language::Assembly:
	case Language::StrictAssembly:
		return EVMDialect::strictAssemblyForEVMObjects(_version);
	case Language::Yul:
		return EVMDialectTyped::instance(_version);
	}
	util::unreachable();
}

void ObjectCache::optimize(Object& _object, Context const& _context, bool _isCreation)
{
	yulAssert(_object.code);
	yulAssert(_object.analysisInfo); // TMP: Do I need this?
	yulAssert(_object.debugData);

	for (auto& subNode: _object.subObjects)
		if (auto subObject = dynamic_cast<Object*>(subNode.get()))
		{
			bool isCreation = !boost::ends_with(subObject->name, "_deployed");
			optimize(
				*subObject,
				_context,
				isCreation
			);
		}

	Dialect const& dialect = languageToDialect(_context.language, _context.evmVersion);
	std::unique_ptr<GasMeter> meter;
	if (EVMDialect const* evmDialect = dynamic_cast<EVMDialect const*>(&dialect))
		meter = std::make_unique<GasMeter>(*evmDialect, _isCreation, _context.expectedExecutionsPerDeployment);

	h256 cacheKey = calculateCacheKey(*_object.code, *_object.debugData, _context, _isCreation);
	if (m_cachedObjects.count(cacheKey) != 0)
	{
		retrieveObject(cacheKey, _object);
		return;
	}

	OptimiserSuite::run(
		dialect,
		meter.get(),
		_object,
		// Defaults are the minimum necessary to avoid running into "Stack too deep" constantly.
		_context.optimizeStackAllocation,
		_context.yulOptimiserSteps,
		_context.yulOptimiserCleanupSteps,
		_isCreation ? std::nullopt : std::make_optional(_context.expectedExecutionsPerDeployment),
		{}
	);

	storeObject(cacheKey, _object);
}

void ObjectCache::storeObject(util::h256 _cacheKey, Object& _object)
{
	m_cachedObjects[_cacheKey] = CachedObject{
		std::make_shared<Block>(ASTCopier{}.translate(*_object.code)),
		_object.analysisInfo,
		_object.debugData,
	};
}

void ObjectCache::retrieveObject(util::h256 _cacheKey, Object& _object) const
{
	solAssert(m_cachedObjects.count(_cacheKey) != 0);
	_object.code = std::make_shared<Block>(ASTCopier{}.translate(*m_cachedObjects.at(_cacheKey).ast));
	_object.analysisInfo = m_cachedObjects.at(_cacheKey).analysisInfo;
	_object.debugData = m_cachedObjects.at(_cacheKey).debugData;
	solAssert(_object.code);
	solAssert(_object.analysisInfo);
	solAssert(_object.debugData);
}

h256 ObjectCache::calculateCacheKey(
	Block const& _ast,
	ObjectDebugData const& _debugData,
	Context const& _context,
	bool _isCreation
)
{
	AsmPrinter asmPrinter(nullptr, _debugData.sourceNames, DebugInfoSelection::All());

	bytes rawKey;
	rawKey += keccak256(asmPrinter(_ast)).asBytes();
	rawKey += h256(u256(_context.language)).asBytes();
	rawKey += h256(u256(_context.optimizeStackAllocation ? 0 : 1)).asBytes();
	rawKey += h256(u256(_context.expectedExecutionsPerDeployment)).asBytes();
	rawKey += h256(u256(_isCreation ? 0 : 1)).asBytes();
	rawKey += keccak256(_context.evmVersion.name()).asBytes();
	rawKey += keccak256(_context.yulOptimiserSteps).asBytes();
	rawKey += keccak256(_context.yulOptimiserCleanupSteps).asBytes();

	// TMP: Do I even need to hash it again here?
	return h256(keccak256(rawKey));
}
