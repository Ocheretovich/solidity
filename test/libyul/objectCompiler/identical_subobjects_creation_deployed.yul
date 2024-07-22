// NOTE: Code was chosen in such a way that the source is identical, but will be optimized
// differently in creation vs deployment with 200 runs.

object "A" {
    code {
        function load(i) -> r { r := calldataload(i) }
        let x := add(shl(255, 1), shl(127, not(0)))
        sstore(load(x), load(1))
    }

    object "B_deployed" {
        code {
            function load(i) -> r { r := calldataload(i) }
            let x := add(shl(255, 1), shl(127, not(0)))
            sstore(load(x), load(1))
        }

        object "A" {
            code {
                function load(i) -> r { r := calldataload(i) }
                let x := add(shl(255, 1), shl(127, not(0)))
                sstore(load(x), load(1))
            }

            object "B_deployed" {
                code {
                    function load(i) -> r { r := calldataload(i) }
                    let x := add(shl(255, 1), shl(127, not(0)))
                    sstore(load(x), load(1))
                }
            }

            object "C" {
                code {
                    function load(i) -> r { r := calldataload(i) }
                    let x := add(shl(255, 1), shl(127, not(0)))
                    sstore(load(x), load(1))
                }
            }
        }
    }

    object "C_deployed" {
        code {
            function load(i) -> r { r := calldataload(i) }
            let x := add(shl(255, 1), shl(127, not(0)))
            sstore(load(x), load(1))
        }
    }

    object "D" {
        code {
            function load(i) -> r { r := calldataload(i) }
            let x := add(shl(255, 1), shl(127, not(0)))
            sstore(load(x), load(1))
        }
    }
}
// ====
// optimizationPreset: full
// ----
// Assembly:
//     /* "source":257:258   */
//   0x01
//     /* "source":209:224   */
//   calldataload
//   calldataload(sub(shl(0xff, 0x01), shl(0x7f, 0x01)))
//     /* "source":287:311   */
//   sstore
//     /* "source":170:317   */
//   stop
// stop
//
// sub_0: assembly {
//         /* "source":453:454   */
//       0x01
//         /* "source":401:416   */
//       calldataload
//       calldataload(shl(0x7f, 0xffffffffffffffffffffffffffffffff))
//         /* "source":487:511   */
//       sstore
//         /* "source":358:521   */
//       stop
//     stop
//
//     sub_0: assembly {
//             /* "source":664:665   */
//           0x01
//             /* "source":608:623   */
//           calldataload
//           calldataload(sub(shl(0xff, 0x01), shl(0x7f, 0x01)))
//             /* "source":702:726   */
//           sstore
//             /* "source":561:740   */
//           stop
//         stop
//
//         sub_0: assembly {
//                 /* "source":908:909   */
//               0x01
//                 /* "source":848:863   */
//               calldataload
//               calldataload(shl(0x7f, 0xffffffffffffffffffffffffffffffff))
//                 /* "source":950:974   */
//               sstore
//                 /* "source":797:992   */
//               stop
//         }
//
//         sub_1: assembly {
//                 /* "source":1165:1166   */
//               0x01
//                 /* "source":1105:1120   */
//               calldataload
//               calldataload(sub(shl(0xff, 0x01), shl(0x7f, 0x01)))
//                 /* "source":1207:1231   */
//               sstore
//                 /* "source":1054:1249   */
//               stop
//         }
//     }
// }
//
// sub_1: assembly {
//         /* "source":1415:1416   */
//       0x01
//         /* "source":1363:1378   */
//       calldataload
//       calldataload(shl(0x7f, 0xffffffffffffffffffffffffffffffff))
//         /* "source":1449:1473   */
//       sstore
//         /* "source":1320:1483   */
//       stop
// }
//
// sub_2: assembly {
//         /* "source":1616:1617   */
//       0x01
//         /* "source":1564:1579   */
//       calldataload
//       calldataload(sub(shl(0xff, 0x01), shl(0x7f, 0x01)))
//         /* "source":1650:1674   */
//       sstore
//         /* "source":1521:1684   */
//       stop
// }
// Bytecode: 6001356001607f1b600160ff1b03355500fe
// Opcodes: PUSH1 0x1 CALLDATALOAD PUSH1 0x1 PUSH1 0x7F SHL PUSH1 0x1 PUSH1 0xFF SHL SUB CALLDATALOAD SSTORE STOP INVALID
// SourceMappings: 257:1:0:-:0;209:15;-1:-1:-1;;;;;;;209:15:0;287:24;170:147
