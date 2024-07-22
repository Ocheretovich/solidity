object "A" {
    code {
        function load(i) -> r { r := calldataload(i) }
        sstore(load(0), load(1))
    }

    object "B" {
        code {
            function load(i) -> r { r := calldataload(i) }
            sstore(load(0), load(1))
        }

        object "A" {
            code {
                function load(i) -> r { r := calldataload(i) }
                sstore(load(0), load(1))
            }

            object "B" {
                code {
                    function load(i) -> r { r := calldataload(i) }
                    sstore(load(0), load(1))
                }
            }

            object "C" {
                code {
                    function load(i) -> r { r := calldataload(i) }
                    sstore(load(0), load(1))
                }
            }
        }
    }

    object "C" {
        code {
            function load(i) -> r { r := calldataload(i) }
            sstore(load(0), load(1))
        }
    }

    object "D" {
        code {
            function load(i) -> r { r := calldataload(i) }
            sstore(load(0), load(1))
        }
    }
}
// ====
// optimizationPreset: full
// ----
// Assembly:
//     /* "source":108:109   */
//   0x01
//     /* "source":61:76   */
//   calldataload
//     /* "source":99:100   */
//   0x00
//     /* "source":61:76   */
//   calldataload
//     /* "source":87:111   */
//   sstore
//     /* "source":22:117   */
//   stop
// stop
//
// sub_0: assembly {
//         /* "source":243:244   */
//       0x01
//         /* "source":192:207   */
//       calldataload
//         /* "source":234:235   */
//       0x00
//         /* "source":192:207   */
//       calldataload
//         /* "source":222:246   */
//       sstore
//         /* "source":149:256   */
//       stop
//     stop
//
//     sub_0: assembly {
//             /* "source":398:399   */
//           0x01
//             /* "source":343:358   */
//           calldataload
//             /* "source":389:390   */
//           0x00
//             /* "source":343:358   */
//           calldataload
//             /* "source":377:401   */
//           sstore
//             /* "source":296:415   */
//           stop
//         stop
//
//         sub_0: assembly {
//                 /* "source":573:574   */
//               0x01
//                 /* "source":514:529   */
//               calldataload
//                 /* "source":564:565   */
//               0x00
//                 /* "source":514:529   */
//               calldataload
//                 /* "source":552:576   */
//               sstore
//                 /* "source":463:594   */
//               stop
//         }
//
//         sub_1: assembly {
//                 /* "source":766:767   */
//               0x01
//                 /* "source":707:722   */
//               calldataload
//                 /* "source":757:758   */
//               0x00
//                 /* "source":707:722   */
//               calldataload
//                 /* "source":745:769   */
//               sstore
//                 /* "source":656:787   */
//               stop
//         }
//     }
// }
//
// sub_1: assembly {
//         /* "source":943:944   */
//       0x01
//         /* "source":892:907   */
//       calldataload
//         /* "source":934:935   */
//       0x00
//         /* "source":892:907   */
//       calldataload
//         /* "source":922:946   */
//       sstore
//         /* "source":849:956   */
//       stop
// }
//
// sub_2: assembly {
//         /* "source":1088:1089   */
//       0x01
//         /* "source":1037:1052   */
//       calldataload
//         /* "source":1079:1080   */
//       0x00
//         /* "source":1037:1052   */
//       calldataload
//         /* "source":1067:1091   */
//       sstore
//         /* "source":994:1101   */
//       stop
// }
// Bytecode: 6001355f355500fe
// Opcodes: PUSH1 0x1 CALLDATALOAD PUSH0 CALLDATALOAD SSTORE STOP INVALID
// SourceMappings: 108:1:0:-:0;61:15;99:1;61:15;87:24;22:95
