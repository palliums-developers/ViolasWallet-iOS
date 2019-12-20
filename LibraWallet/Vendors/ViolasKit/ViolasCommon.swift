//
//  ViolasCommon.swift
//  LibraWallet
//
//  Created by palliums on 2019/12/13.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit
/// Violas签名盐
let ViolasSignSalt  = "RawTransaction::libra_types::transaction@@$$LIBRA$$@@"
//let violasSignSalt  = "RawTransaction@@$$LIBRA$$@@"

/// Violas计算助记词盐
let ViolasMnemonicSalt = "LIBRA WALLET: mnemonic salt prefix$LIBRA"

/// 开启代币ProgramCode(publish.mv)
let ViolasPublishProgramCode = "{\"code\":[76,73,66,82,65,86,77,10,1,0,7,1,74,0,0,0,4,0,0,0,3,78,0,0,0,6,0,0,0,13,84,0,0,0,4,0,0,0,14,88,0,0,0,2,0,0,0,5,90,0,0,0,32,0,0,0,4,122,0,0,0,64,0,0,0,8,186,0,0,0,11,0,0,0,0,0,1,1,0,2,0,1,3,0,2,0,0,0,3,0,6,60,83,69,76,70,62,11,86,105,111,108,97,115,84,111,107,101,110,4,109,97,105,110,7,112,117,98,108,105,115,104,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,114,87,194,65,126,77,16,56,225,129,124,143,40,58,206,46,16,65,179,57,108,219,176,153,235,53,123,190,224,36,214,20,0,1,0,1,0,2,0,19,1,0,2],\"args\":[]}"

/// Violas代币转账ProgramCode(transfer.mv)
let ViolasTransactionProgramCode = "{\"code\":[76,73,66,82,65,86,77,10,1,0,7,1,74,0,0,0,4,0,0,0,3,78,0,0,0,6,0,0,0,13,84,0,0,0,6,0,0,0,14,90,0,0,0,6,0,0,0,5,96,0,0,0,33,0,0,0,4,129,0,0,0,64,0,0,0,8,193,0,0,0,15,0,0,0,0,0,1,1,0,2,0,1,3,0,2,0,2,4,2,0,3,2,4,2,3,0,6,60,83,69,76,70,62,11,86,105,111,108,97,115,84,111,107,101,110,4,109,97,105,110,8,116,114,97,110,115,102,101,114,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,114,87,194,65,126,77,16,56,225,129,124,143,40,58,206,46,16,65,179,57,108,219,176,153,235,53,123,190,224,36,214,20,0,1,0,2,0,4,0,12,0,12,1,19,1,1,2],\"args\":[]}"
/// Violas代币兑换ProgramCode(transfer_with_data.mv)(3.0)
let ViolasExchangeTokenProgramCode = "{\"code\":[76,73,66,82,65,86,77,10,1,0,7,1,74,0,0,0,4,0,0,0,3,78,0,0,0,6,0,0,0,13,84,0,0,0,7,0,0,0,14,91,0,0,0,7,0,0,0,5,98,0,0,0,43,0,0,0,4,141,0,0,0,64,0,0,0,8,205,0,0,0,17,0,0,0,0,0,1,1,0,2,0,1,3,0,2,0,3,4,2,8,0,3,3,4,2,8,3,0,6,60,83,69,76,70,62,11,86,105,111,108,97,115,84,111,107,101,110,4,109,97,105,110,18,116,114,97,110,115,102,101,114,95,119,105,116,104,95,100,97,116,97,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,114,87,194,65,126,77,16,56,225,129,124,143,40,58,206,46,16,65,179,57,108,219,176,153,235,53,123,190,224,36,214,20,0,1,0,3,0,5,0,12,0,12,1,12,2,19,1,1,2],\"args\":[]}"