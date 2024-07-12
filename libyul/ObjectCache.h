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

#pragma once

#include <libyul/ASTForward.h>
#include <libyul/Object.h>

#include <liblangutil/EVMVersion.h>

#include <libsolutil/FixedHash.h>

#include <map>
#include <memory>
#include <optional>

namespace solidity::yul
{

// TMP: Move this to a more general place?
enum class Language
{
	Yul,
	Assembly,
	StrictAssembly,
};

Dialect const& languageToDialect(Language _language, langutil::EVMVersion _version);

class ObjectCache
{
public:
	struct Context
	{
		Language language;
		langutil::EVMVersion evmVersion;
		bool optimizeStackAllocation;
		std::string yulOptimiserSteps;
		std::string yulOptimiserCleanupSteps;
		size_t expectedExecutionsPerDeployment;
	};

	void optimize(Object& _object, Context const& _context) { optimize(_object, _context, true); }

private:
	struct CachedObject
	{
		std::shared_ptr<Block const> ast;
		std::shared_ptr<AsmAnalysisInfo> analysisInfo; // TMP: is it really ok to share this without copying?
		std::shared_ptr<ObjectDebugData const> debugData;
	};

	void optimize(Object& _object, Context const& _context, bool _isCreation);

	// TMP: _object should be const here
	void storeObject(util::h256 _cacheKey, Object& _object);
	void retrieveObject(util::h256 _cacheKey, Object& _object) const;

	static util::h256 calculateCacheKey(
		Block const& _ast,
		ObjectDebugData const& _debugData,
		Context const& _context,
		bool _isCreation
	);

	std::map<util::h256, CachedObject> m_cachedObjects;
};

}
