//
//  LibraCommon.swift
//  LibraWallet
//
//  Created by palliums on 2019/12/18.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit

/// Libra签名盐
let LibraSignSalt  = "LIBRA::RawTransaction"
/// LIbra计算助记词盐
let LibraMnemonicSalt = "LIBRA WALLET: mnemonic salt prefix$LIBRA"
/// Libra交易Code（无脚本）
//let libraScriptCode = "a11ceb0b010007014600000002000000034800000011000000045900000004000000055d0000001400000007710000003b00000008ac0000001000000009bc0000001e000000000000010001010100020203000003040101010006020602050a02000105010102050303050a02030109000c4c696272614163636f756e74166372656174655f746573746e65745f6163636f756e74066578697374730f7061795f66726f6d5f73656e64657200000000000000000000000000000000010105010c000a001101200305000508000a000a0138000a000a02380102"
/// Libra交易Code（有脚本）
let LibraScriptCodeWithData = "a11ceb0b010007014600000002000000034800000006000000044e0000000200000005500000000d000000075d000000240000000881000000100000000991000000130000000000000100010101000205060c05030a020a02000109000c4c696272614163636f756e74167061795f66726f6d5f776974685f6d65746164617461000000000000000000000000000000000101000107000b000a010a020b030b04380002"

let LibraPublishScriptCode = "a11ceb0b010007014600000002000000034800000006000000044e0000000200000005500000000700000007570000001a00000008710000001000000009810000000b0000000000000100010101000201060c000109000c4c696272614163636f756e740c6164645f63757272656e6379000000000000000000000000000000000101000103000b00380002"
