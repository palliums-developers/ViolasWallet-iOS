//
//  ViolasSDKTests.swift
//  ViolasWalletTests
//
//  Created by wangyingdong on 2021/2/22.
//  Copyright © 2021 palliums. All rights reserved.
//

import XCTest
import CryptoSwift

@testable import ViolasPay
class ViolasSDKTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testViolasKit() {
        //LibraTransactionArgument
        // u64
        let amount = ViolasTransactionArgument.init(code: .U64(9213671392124193148)).serialize().toHexString().uppercased()
        XCTAssertEqual(amount, "017CC9BDA45089DD7F")
        // Address
        let address = ViolasTransactionArgument.init(code: .Address("bafc671e8a38c05706f83b5159bbd8a4")).serialize().toHexString()
        XCTAssertEqual(address  , "03bafc671e8a38c05706f83b5159bbd8a4")
        // U8Vector
        let u8vector = ViolasTransactionArgument.init(code: .U8Vector(Data.init(Array<UInt8>(hex: "CAFED00D")))).serialize().toHexString().uppercased()
        XCTAssertEqual(u8vector, "0404CAFED00D")
        // Bool
        let bool1 = ViolasTransactionArgument.init(code: .Bool(false)).serialize().toHexString().uppercased()
        XCTAssertEqual(bool1, "0500")
        // Bool
        let bool2 = ViolasTransactionArgument.init(code: .Bool(true)).serialize().toHexString().uppercased()
        XCTAssertEqual(bool2, "0501")
        //LibraTransactionAccessPath
        let accessPath1 = ViolasAccessPath.init(address: "a71d76faa2d2d5c3224ec3d41deb2939",
                                               path: "01217da6c6b3e19f1825cfb2676daecce3bf3de03cf26647c78df00b371b25cc97",
                                               writeOp: .Deletion)
        let accessPath2 = ViolasAccessPath.init(address: "c4c63f80c74b11263e421ebf8486a4e3",
                                               path: "01217da6c6b3e19f18",
                                               writeOp: .Value(Data.init(Array<UInt8>(hex: "CAFED00D"))))
        let writeSet = ViolasWriteSet.init(accessPaths: [accessPath1, accessPath2])
        let writeSetCheckData: Array<UInt8> = [0x02, 0xA7, 0x1D, 0x76, 0xFA, 0xA2, 0xD2, 0xD5, 0xC3, 0x22, 0x4E, 0xC3, 0xD4, 0x1D, 0xEB,
                                               0x29, 0x39, 0x21, 0x01, 0x21, 0x7D, 0xA6, 0xC6, 0xB3, 0xE1, 0x9F, 0x18, 0x25, 0xCF, 0xB2,
                                               0x67, 0x6D, 0xAE, 0xCC, 0xE3, 0xBF, 0x3D, 0xE0, 0x3C, 0xF2, 0x66, 0x47, 0xC7, 0x8D, 0xF0,
                                               0x0B, 0x37, 0x1B, 0x25, 0xCC, 0x97, 0x00, 0xC4, 0xC6, 0x3F, 0x80, 0xC7, 0x4B, 0x11, 0x26,
                                               0x3E, 0x42, 0x1E, 0xBF, 0x84, 0x86, 0xA4, 0xE3, 0x09, 0x01, 0x21, 0x7D, 0xA6, 0xC6, 0xB3,
                                               0xE1, 0x9F, 0x18, 0x01, 0x04, 0xCA, 0xFE, 0xD0, 0x0D]
        XCTAssertEqual(writeSet.serialize().toHexString().lowercased(), Data.init(writeSetCheckData).toHexString())
        // LibraTransactionPayload_WriteSet
        let writeSetPayload = ViolasTransactionWriteSetPayload.init(code: .direct(writeSet, [ViolasContractEvent]()))
        let transactionWriteSetPayload = ViolasTransactionPayload.init(payload: .writeSet(writeSetPayload))
        let writeSetPayloadData: Array<UInt8> = [0, 0, 2, 167, 29, 118, 250, 162, 210, 213, 195, 34, 78, 195, 212, 29, 235, 41, 57, 33, 1,
                                                 33, 125, 166, 198, 179, 225, 159, 24, 37, 207, 178, 103, 109, 174, 204, 227, 191, 61, 224,
                                                 60, 242, 102, 71, 199, 141, 240, 11, 55, 27, 37, 204, 151, 0, 196, 198, 63, 128, 199, 75,
                                                 17, 38, 62, 66, 30, 191, 132, 134, 164, 227, 9, 1, 33, 125, 166, 198, 179, 225, 159, 24, 1,
                                                 4, 202, 254, 208, 13, 0]
        
        XCTAssertEqual(transactionWriteSetPayload.serialize().toHexString().lowercased(), Data.init(writeSetPayloadData).toHexString())
        // LibraTransactionPayload_Module
        let module = ViolasTransactionPayload.init(payload: .module(ViolasTransactionModulePayload.init(code: Data.init(Array<UInt8>(hex: "CAFED00D")))))
        XCTAssertEqual(module.serialize().toHexString().uppercased(), "02CAFED00D")
        let writeSetRaw = ViolasRawTransaction.init(senderAddres: "c3398a599a6f3b9f30b635af29f2ba04",
                                                   sequenceNumber: 32,
                                                   maxGasAmount: 0,
                                                   gasUnitPrice: 0,
                                                   expirationTime: UINT64_MAX,
                                                   payload: transactionWriteSetPayload,
                                                   module: "XUS",
                                                   chainID: 4)
        let rawTransactioinWriteSetCheckData: Array<UInt8> = [195, 57, 138, 89, 154, 111, 59, 159, 48, 182, 53, 175, 41, 242, 186, 4, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 167, 29, 118, 250, 162, 210, 213, 195, 34, 78, 195, 212, 29, 235, 41, 57, 33, 1, 33, 125, 166, 198, 179, 225, 159, 24, 37, 207, 178, 103, 109, 174, 204, 227, 191, 61, 224, 60, 242, 102, 71, 199, 141, 240, 11, 55, 27, 37, 204, 151, 0, 196, 198, 63, 128, 199, 75, 17, 38, 62, 66, 30, 191, 132, 134, 164, 227, 9, 1, 33, 125, 166, 198, 179, 225, 159, 24, 1, 4, 202, 254, 208, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 88, 85, 83, 255, 255, 255, 255, 255, 255, 255, 255, 4]
        XCTAssertEqual(writeSetRaw.serialize().toHexString().lowercased(), Data.init(rawTransactioinWriteSetCheckData).toHexString())
        // LibraTransactionPayload_Script
        let transactionScript = ViolasTransactionScriptPayload.init(code: ("move".data(using: .utf8)!),
                                                                   typeTags: [ViolasTypeTag](),//
                                                                   argruments: [ViolasTransactionArgument.init(code: .U64(14627357397735030511))])
        let transactionScriptPayload = ViolasTransactionPayload.init(payload: .script(transactionScript))
        let scriptRaw = ViolasRawTransaction.init(senderAddres: "3a24a61e05d129cace9e0efc8bc9e338",
                                                 sequenceNumber: 32,
                                                 maxGasAmount: 10000,
                                                 gasUnitPrice: 20000,
                                                 expirationTime: 86400,
                                                 payload: transactionScriptPayload,
                                                 module: "XUS",
                                                 chainID: 4)
        let rawTransactioinScriptCheckData: Array<UInt8> = [58, 36, 166, 30, 5, 209, 41, 202, 206, 158, 14, 252, 139, 201, 227, 56, 32, 0, 0, 0, 0, 0, 0, 0, 1, 4, 109, 111, 118, 101, 0, 1, 1, 239, 190, 173, 222, 13, 208, 254, 202, 16, 39, 0, 0, 0, 0, 0, 0, 32, 78, 0, 0, 0, 0, 0, 0, 3, 88, 85, 83, 128, 81, 1, 0, 0, 0, 0, 0, 4]
        XCTAssertEqual(scriptRaw.serialize().toHexString().lowercased(), Data.init(rawTransactioinScriptCheckData).toHexString())
    }
    func testViolasKitSingle() {
        let mnemonic = ["display", "paddle", "crush", "crowd", "often", "friend", "topple", "agent", "entry", "use", "begin", "host"]
        //5be7a2fd7d12353121d4702fcfa4ab42-
        //token = ba006842b6bfbef4fef8eb2db37dc9bc
        
//        let mnemonic = ["grant", "security", "cluster", "pill", "visit", "wave", "skull", "chase", "vibrant", "embrace", "bronze", "tip"]
        //643eb4651234bde53a7d865f61ed96f8
        //token = ba006842b6bfbef4fef8eb2db37dc9bc
        
//        let mnemonic = ["net", "dice", "divide", "amount", "stamp", "flock", "brave", "nuclear", "fox", "aim", "father", "apology"]
        //1783c560a50bff9cf8b4a55f67fac776
        //token = ba006842b6bfbef4fef8eb2db37dc9bc
//        let mnemonic = ["trouble", "menu", "nephew", "group", "alert", "recipe", "hotel", "fatigue", "wet", "shadow", "say", "fold", "huge", "olive", "solution", "enjoy", "garden", "appear", "vague", "joy", "great", "keep", "cactus", "melt"]

        do {
            let seed = try ViolasMnemonic.seed(mnemonic: mnemonic)
            let wallet = try ViolasHDWallet.init(seed: seed, network: .testing)
            print(wallet.publicKey.toLegacy())
//            let signature = try DiemManager.getNormalTransactionHex(sendAddress: "643eb4651234bde53a7d865f61ed96f8",
//                                                                    receiveAddress: "6c1dd50f35f120061babc2814cf9378b",
//                                                                    amount: 1000000,
//                                                                    fee: 1,
//                                                                    mnemonic: mnemonic,
//                                                                    sequenceNumber: 5,
//                                                                    module: "XUS",
//                                                                    toSubAddress: "",
//                                                                    fromSubAddress: "",
//                                                                    referencedEvent: "")
//            print(signature)
            print("Success")
        } catch {
            print(error.localizedDescription)
        }
    }
    func testViolasKitMulti() {
        let mnemonic1 = ["display", "paddle", "crush", "crowd", "often", "friend", "topple", "agent", "entry", "use", "begin", "host"]
        let mnemonic2 = ["grant", "security", "cluster", "pill", "visit", "wave", "skull", "chase", "vibrant", "embrace", "bronze", "tip"]
        let mnemonic3 = ["net", "dice", "divide", "amount", "stamp", "flock", "brave", "nuclear", "fox", "aim", "father", "apology"]
        do {
            let seed1 = try ViolasMnemonic.seed(mnemonic: mnemonic1)
            let seed2 = try ViolasMnemonic.seed(mnemonic: mnemonic2)
            let seed3 = try ViolasMnemonic.seed(mnemonic: mnemonic3)
            let seedModel1 = ViolasSeedAndDepth.init(seed: seed1, depth: 0, sequence: 0)
            let seedModel2 = ViolasSeedAndDepth.init(seed: seed2, depth: 0, sequence: 1)
            let seedModel3 = ViolasSeedAndDepth.init(seed: seed3, depth: 0, sequence: 2)
            let multiPublicKey = ViolasMultiPublicKey.init(data: [ViolasMultiPublicKeyModel.init(raw: Data.init(Array<UInt8>(hex: "e12136fd95251348cd993b91e8fbf36bcebe9422842f3c505ca2893f5612ae53")), sequence: 0),
                                                                ViolasMultiPublicKeyModel.init(raw: Data.init(Array<UInt8>(hex: "ee2586aaaeaaa39ae4eb601999e5c2aade701ac4262f79ac98d9413cce67b0db")), sequence: 1),
                                                                ViolasMultiPublicKeyModel.init(raw: Data.init(Array<UInt8>(hex: "d0b27e06a1bf428c380bd10b7469d8b4f251e763724b2543c730abcaea18c8b0")), sequence: 2)],
                                                          threshold: 2,
                                                          network: .testing)
            let wallet = try ViolasMultiHDWallet.init(models: [seedModel1, seedModel2, seedModel3], threshold: 2, multiPublicKey: multiPublicKey, network: .testing)
            //            let wallet = try LibraMultiHDWallet.init(models: [seedModel1, seedModel2, seedModel3], threshold: 2)
            print("Legacy = \(wallet.publicKey.toLegacy())")
            //0d6a04436002d61228a3b58d3f0ecc71
            print("Authentionkey = \(wallet.publicKey.toAuthKey())")
            //df8c99ad74f921563f3f7242b4a3e4570d6a04436002d61228a3b58d3f0ecc71
            print("PublicKey = \(wallet.publicKey.toMultiPublicKey().toHexString())")
            //e12136fd95251348cd993b91e8fbf36bcebe9422842f3c505ca2893f5612ae53ee2586aaaeaaa39ae4eb601999e5c2aade701ac4262f79ac98d9413cce67b0dbd0b27e06a1bf428c380bd10b7469d8b4f251e763724b2543c730abcaea18c8b002
            let sign = try ViolasManager.getMultiTransactionHex(sendAddress: multiPublicKey.toLegacy(),
                                                                receiveAddress: "b5bf62e2f3e1448efa18b1a63f6da1ff",
                                                                amount: 1000000,
                                                                fee: 1,
                                                                sequenceNumber: 1,
                                                                wallet: wallet,
                                                                module: "VLS",
                                                                feeModule: "VLS")
            print(sign)
            print("Success")
        } catch {
            print(error.localizedDescription)
        }
    }

}
