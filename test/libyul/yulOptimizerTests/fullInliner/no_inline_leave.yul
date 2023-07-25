{
    function g() -> x { x := 8 leave }
	function f(a) { a := g() }
    let a1 := calldataload(0)
    f(a1)
}
// ====
// EVMVersion: >=shanghai
// ----
// step: fullInliner
//
// {
//     {
//         let a_1 := calldataload(0)
//         a_1 := g()
//     }
//     function g() -> x
//     {
//         x := 8
//         leave
//     }
//     function f(a)
//     { a := g() }
// }
