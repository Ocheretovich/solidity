object "A" {
    code {
        function load(i) -> r { r := calldataload(i) }
        sstore(load(0), load(dataoffset("B")))
    }

    object "B" {
        code {
            function load(i) -> r { r := calldataload(i) }
            sstore(load(0), load(dataoffset("A")))
        }

        object "A" {
            code {
                function load(i) -> r { r := calldataload(i) }
                sstore(load(0), load(dataoffset("B")))
            }

            object "B" {
                code {
                    function load(i) -> r { r := calldataload(i) }
                    sstore(load(0), load(dataoffset("A")))
                }

                data "A" "0xaa"
            }

            object "C" {
                code {
                    function load(i) -> r { r := calldataload(i) }
                    sstore(load(0), load(dataoffset("A")))
                }

                data "A" "0xbb"
            }
        }
    }

    object "C" {
        code {
            function load(i) -> r { r := calldataload(i) }
            sstore(load(0), load(dataoffset("A")))
        }

        data "A" "0xcc"
    }

    object "D" {
        code {
            function load(i) -> r { r := calldataload(i) }
            sstore(load(0), load(dataoffset("A")))
        }

        data "A" "0xdd"
    }
}
// ====
// optimizationPreset: full
// ----
// Assembly:
//     /* "source":108:123   */
//   dataOffset(sub_0)
//     /* "source":61:76   */
//   calldataload
//     /* "source":99:100   */
//   0x00
//     /* "source":61:76   */
//   calldataload
//     /* "source":87:125   */
//   sstore
//     /* "source":22:131   */
//   stop
// stop
//
// sub_0: assembly {
//         /* "source":257:272   */
//       dataOffset(sub_0)
//         /* "source":206:221   */
//       calldataload
//         /* "source":248:249   */
//       0x00
//         /* "source":206:221   */
//       calldataload
//         /* "source":236:274   */
//       sstore
//         /* "source":163:284   */
//       stop
//     stop
//
//     sub_0: assembly {
//             /* "source":426:441   */
//           dataOffset(sub_0)
//             /* "source":371:386   */
//           calldataload
//             /* "source":417:418   */
//           0x00
//             /* "source":371:386   */
//           calldataload
//             /* "source":405:443   */
//           sstore
//             /* "source":324:457   */
//           stop
//         stop
//
//         sub_0: assembly {
//                 /* "source":615:630   */
//               data_89b1fd0f9a40d0a598af5f997daf99fc3d5b98ef4eb429e81755ae0ee49e194e
//                 /* "source":556:571   */
//               calldataload
//                 /* "source":606:607   */
//               0x00
//                 /* "source":556:571   */
//               calldataload
//                 /* "source":594:632   */
//               sstore
//                 /* "source":505:650   */
//               stop
//             stop
//             data_89b1fd0f9a40d0a598af5f997daf99fc3d5b98ef4eb429e81755ae0ee49e194e 30786161
//         }
//
//         sub_1: assembly {
//                 /* "source":855:870   */
//               data_736ddcdd19b41ff3aa09bd89628fc69562c2e39bdb07c1971217d2e374ce6e27
//                 /* "source":796:811   */
//               calldataload
//                 /* "source":846:847   */
//               0x00
//                 /* "source":796:811   */
//               calldataload
//                 /* "source":834:872   */
//               sstore
//                 /* "source":745:890   */
//               stop
//             stop
//             data_736ddcdd19b41ff3aa09bd89628fc69562c2e39bdb07c1971217d2e374ce6e27 30786262
//         }
//     }
// }
//
// sub_1: assembly {
//         /* "source":1079:1094   */
//       data_07eb8622d9d50f8018ea32eb76eed1e3335185c75ef1fb18e4c72b7f4b09113b
//         /* "source":1028:1043   */
//       calldataload
//         /* "source":1070:1071   */
//       0x00
//         /* "source":1028:1043   */
//       calldataload
//         /* "source":1058:1096   */
//       sstore
//         /* "source":985:1106   */
//       stop
//     stop
//     data_07eb8622d9d50f8018ea32eb76eed1e3335185c75ef1fb18e4c72b7f4b09113b 30786363
// }
//
// sub_2: assembly {
//         /* "source":1263:1278   */
//       data_aded71d4841db5a5b399556233f75fea6df40a1efa9b5882c1abe020c32560ed
//         /* "source":1212:1227   */
//       calldataload
//         /* "source":1254:1255   */
//       0x00
//         /* "source":1212:1227   */
//       calldataload
//         /* "source":1242:1280   */
//       sstore
//         /* "source":1169:1290   */
//       stop
//     stop
//     data_aded71d4841db5a5b399556233f75fea6df40a1efa9b5882c1abe020c32560ed 30786464
// }
// Bytecode: 6008355f355500fe6008355f355500fe6008355f355500fe6008355f355500fe30786161
// Opcodes: PUSH1 0x8 CALLDATALOAD PUSH0 CALLDATALOAD SSTORE STOP INVALID PUSH1 0x8 CALLDATALOAD PUSH0 CALLDATALOAD SSTORE STOP INVALID PUSH1 0x8 CALLDATALOAD PUSH0 CALLDATALOAD SSTORE STOP INVALID PUSH1 0x8 CALLDATALOAD PUSH0 CALLDATALOAD SSTORE STOP INVALID ADDRESS PUSH25 0x61610000000000000000000000000000000000000000000000
// SourceMappings: 108:15:0:-:0;61;99:1;61:15;87:38;22:109
