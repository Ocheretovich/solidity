{
    let c := calldataload(0)
    // This store will be overwritten in all branches and thus can be removed.
    sstore(c, 1)
    if c {
        sstore(c, 2)
    }
    sstore(c, 3)
}
// ====
// EVMVersion: >=shanghai
// ----
// step: unusedStoreEliminator
//
// {
//     {
//         let c := calldataload(0)
//         let _1 := 1
//         if c { let _2 := 2 }
//         sstore(c, 3)
//     }
// }
