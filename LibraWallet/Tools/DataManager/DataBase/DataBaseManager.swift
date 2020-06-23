//
//  DataBaseManager.swift
//  LibraWallet
//
//  Created by palliums on 2019/9/11.
//  Copyright © 2019 palliums. All rights reserved.
//

import Foundation
import SQLite
struct DataBaseManager {
    static var DBManager = DataBaseManager()
    var db: Connection?
    mutating func creatLocalDataBase() {
        /// 获取沙盒地址
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        /// 拼接路径
        let filePath = "\(path[0])" + "/" + "PalliumsWallet.sqlite3"
        print(filePath)
        do {
            self.db = try Connection(filePath)
        } catch {
            print("CreateDataBaseError")
        }
    }
    func isExistTable(name: String) -> Bool {
        do {
            let walletTable = Table(name)
            _ = try db!.scalar(walletTable.count)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
extension DataBaseManager {
    func createWalletTable() {
        /// 判断是否存在表
        guard isExistTable(name: "Wallet") == false else {
            return
        }
        do {
            if let tempDB = self.db {
                let walletTable = Table("Wallet")
                // 钱包序号
                let walletID = Expression<Int64>("wallet_id")
                // 钱包名字
                let walletName = Expression<String>("wallet_name")
                // 钱包创建时间
                let walletCreateTime = Expression<Double>("wallet_creat_time")
                // 是否使用生物解锁
                let walletBiometricLock = Expression<Bool>("wallet_biometric_lock")
                // 钱包创建类型(0导入、1创建)
                let walletCreateType = Expression<Int>("wallet_create_type")
                // 钱包是否已备份
                let walletBackupState = Expression<Bool>("wallet_backup_state")
                // 当前WalletConnect订阅钱包
                let walletSubscription = Expression<Bool>("wallet_subscription")
                // 助记词哈希
                let walletMnemonicHash = Expression<String>("wallet_mnemonic_hash")
                // 钱包使用状态
                let walletUseState = Expression<Bool>("wallet_use_state")
                // 建表
                try tempDB.run(walletTable.create { t in
                    t.column(walletID, primaryKey: true)
                    t.column(walletCreateTime)
                    t.column(walletName)
                    t.column(walletSubscription)
                    t.column(walletBiometricLock)
                    t.column(walletCreateType)
                    t.column(walletBackupState)
                    t.column(walletMnemonicHash, unique: true)
                    t.column(walletUseState)
                })
            }
        } catch {
            let errorString = error.localizedDescription
            if errorString.hasSuffix("already exists") == true {
                return
            } else {
                print(errorString)
            }
        }
    }
    func insertWallet(model: WalletManager) throws {
        
        let walletTable = Table("Wallet")
        do {
            guard let tempDB = self.db else {
                throw LibraWalletError.WalletDataBase(reason: .openDataBaseError)
            }
            let insert = walletTable.insert(
                Expression<String>("wallet_name") <- model.walletName ?? "",
                Expression<Double>("wallet_creat_time") <- model.walletCreateTime ?? 0,
                Expression<Bool>("wallet_biometric_lock") <- model.walletBiometricLock ?? false,
                Expression<Int>("wallet_create_type") <- model.walletCreateType ?? 999,
                Expression<Bool>("wallet_backup_state") <- model.walletBackupState ?? false,
                Expression<Bool>("wallet_subscription") <- model.walletSubscription ?? false,
                Expression<String>("wallet_mnemonic_hash") <- model.walletMnemonicHash ?? "",
                Expression<Bool>("wallet_use_state") <- model.walletUseState ?? false)
            let rowid = try tempDB.run(insert)
            print(rowid)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    func isExistWalletInWallet(wallet: WalletManager) throws -> Bool {
        let walletTable = Table("Wallet")
        do {
            guard let tempDB = self.db else {
                throw LibraWalletError.WalletDataBase(reason: .openDataBaseError)
            }
            let transection = walletTable.filter(Expression<String>("wallet_mnemonic_hash") == wallet.walletMnemonicHash ?? "")
            let count = try tempDB.scalar(transection.count)
            guard count != 0 else {
                return false
            }
            return true
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    func getLocalWallets() -> WalletManager {
        let walletTable = Table("Wallet")
        do {
            // 身份钱包
            if let tempDB = self.db {
                let table = walletTable.filter(Expression<Bool>("wallet_use_state") == true)

                for wallet in try tempDB.prepare(table) {
                    // 钱包序号
                    let walletID = wallet[Expression<Int64>("wallet_id")]
                    // 钱包名字
                    let walletName = wallet[Expression<String>("wallet_name")]
                    // 钱包创建时间
                    let walletCreateTime = wallet[Expression<Double>("wallet_creat_time")]
                    // 是否使用生物解锁
                    let walletBiometricLock = wallet[Expression<Bool>("wallet_biometric_lock")]
                    // 钱包创建类型(0导入、1创建)
                    let walletCreateType = wallet[Expression<Int>("wallet_create_type")]
                    // 钱包是否已备份
                    let walletBackupState = wallet[Expression<Bool>("wallet_backup_state")]
                    // 当前WalletConnect订阅钱包
                    let walletSubscription = wallet[Expression<Bool>("wallet_subscription")]
                    // 助记词哈希
                    let walletMnemonicHash = wallet[Expression<String>("wallet_mnemonic_hash")]
                    // 钱包使用状态
                    let walletUseState = wallet[Expression<Bool>("wallet_use_state")]

                    WalletManager.shared.initWallet(walletID: walletID,
                                                    walletName: walletName,
                                                    walletCreateTime: walletCreateTime,
                                                    walletBiometricLock: walletBiometricLock,
                                                    walletCreateType: walletCreateType,
                                                    walletBackupState: walletBackupState,
                                                    walletSubscription: walletSubscription,
                                                    walletMnemonicHash: walletMnemonicHash,
                                                    walletUseState: walletUseState)
                    return WalletManager.shared
                }
                return WalletManager.shared
            } else {
                return WalletManager.shared
            }
        } catch {
            print(error.localizedDescription)
            return WalletManager.shared
        }
    }
//    func getWalletWithType(walletType: WalletType) -> [LibraWalletManager] {
//        let walletTable = Table("Wallet").filter(Expression<Int>("wallet_type") == walletType.value)
//        do {
//            // 身份钱包
//            var allWallets = [LibraWalletManager]()
//            if let tempDB = self.db {
//                for wallet in try tempDB.prepare(walletTable) {
//                    // 钱包ID
//                    let walletID = wallet[Expression<Int64>("wallet_id")]
//                    // 钱包金额
//                    let walletBalance = wallet[Expression<Int64>("wallet_balance")]
//                    // 钱包地址
//                    let walletAddress = wallet[Expression<String>("wallet_address")]
//                    // 钱包创建时间
//                    let walletCreateTime = wallet[Expression<Double>("wallet_creat_time")]
//                    // 钱包名字
//                    let walletName = wallet[Expression<String>("wallet_name")]
//                    // 当前WalletConnect订阅钱包
//                    let walletSubscription = wallet[Expression<Bool>("wallet_subscription")]
//                    // 账户是否开启生物锁定
//                    let walletBiometricLock = wallet[Expression<Bool>("wallet_biometric_lock")]
//                    // 钱包创建类型(0导入、1创建)
//                    let walletCreateType = wallet[Expression<Int>("wallet_create_type")]
//                    // 钱包类型(0=Libra、1=Violas、2=BTC)
//                    let walletType = wallet[Expression<Int>("wallet_type")]
//                    // 钱包当前使用层数
//                    let walletIndex = wallet[Expression<Int>("wallet_index")]
//                    // 授权Key
//                    let authenticationKey = wallet[Expression<String>("wallet_authentication_key")]
//                    // 钱包激活状态
//                    let walletActiveState = wallet[Expression<Bool>("wallet_active_state")]
//
//                    let type: WalletType
//                    if walletType == 0 {
//                        type = .Libra
//                    } else if walletType == 1 {
//                        type = .Violas
//                    } else {
//                        type = .BTC
//                    }
//                    // 钱包是否已备份
//                    let walletBackupState = wallet[Expression<Bool>("wallet_backup_state")]
//                    // 钱包标志
//                    let walletIcon = wallet[Expression<String>("wallet_icon")]
//
//                    // 钱包合约地址
//                    let walletContract = wallet[Expression<String>("wallet_contract")]
//                    // 钱包合约名称
//                    let walletModule = wallet[Expression<String>("wallet_module")]
//                    // 钱包合约名称
//                    let walletModuleName = wallet[Expression<String>("wallet_module_name")]
//
//                    let wallet = LibraWalletManager.init(walletID: walletID,
//                                                         walletBalance: walletBalance,
//                                                         walletAddress: walletAddress,
//                                                         walletCreateTime: walletCreateTime,
//                                                         walletName: walletName,
//                                                         walletSubscription: walletSubscription,
//                                                         walletBiometricLock: walletBiometricLock,
//                                                         walletCreateType: walletCreateType,
//                                                         walletType: type,
//                                                         walletIndex: walletIndex,
//                                                         walletBackupState: walletBackupState,
//                                                         walletAuthenticationKey: authenticationKey,
//                                                         walletActiveState: walletActiveState,
//                                                         walletIcon: walletIcon,
//                                                         walletContract: walletContract,
//                                                         walletModule: walletModule,
//                                                         walletModuleName: walletModuleName)
//                    allWallets.append(wallet)
//                }
//                return allWallets
//            } else {
//                return allWallets
//            }
//        } catch {
//            print(error.localizedDescription)
//            return [LibraWalletManager]()
//        }
//    }
//    func updateDefaultViolasWallet() -> Bool {
//        let walletTable = Table("Wallet")
//        do {
//            if let tempDB = self.db {
//                let table = walletTable.filter(Expression<Bool>("wallet_use_state") == true)
//                try tempDB.run(table.update(Expression<Bool>("wallet_current_use") <- false))
//                return true
//            } else {
//                return false
//            }
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
//    }
    func deleteWalletFromTable(model: WalletManager) -> Bool {
        let transectionAddressHistoryTable = Table("Wallet")
        do {
            if let tempDB = self.db {
                let contract = transectionAddressHistoryTable.filter(Expression<Int64>("wallet_id") == model.walletID ?? 9999)
                let rowid = try tempDB.run(contract.delete())
                print(rowid)
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
//    func updateWalletBalance(walletID: Int64, balance: Int64) -> Bool {
//        let walletTable = Table("Wallet")
//        do {
//            if let tempDB = self.db {
//                let contract = walletTable.filter(Expression<Int64>("wallet_id") == walletID)
//                try tempDB.run(contract.update(Expression<Int64>("wallet_balance") <- balance))
//                return true
//            } else {
//                return false
//            }
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
//    }
//    func updateWalletName(walletID: Int64, name: String) -> Bool {
//        let walletTable = Table("Wallet")
//        do {
//            if let tempDB = self.db {
//                let contract = walletTable.filter(Expression<Int64>("wallet_id") == walletID)
//                try tempDB.run(contract.update(Expression<String>("wallet_name") <- name))
//                return true
//            } else {
//                return false
//            }
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
//    }
    func updateWalletBiometricLockState(walletID: Int64, state: Bool) -> Bool {
        let walletTable = Table("Wallet")
        do {
            if let tempDB = self.db {
                let contract = walletTable.filter(Expression<Int64>("wallet_id") == walletID)
                try tempDB.run(contract.update(Expression<Bool>("wallet_biometric_lock") <- state))
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func updateWalletCurrentUseState(walletID: Int64, state: Bool) -> Bool {
        let walletTable = Table("Wallet")
        do {
            if let tempDB = self.db {
                let contract = walletTable.filter(Expression<Int64>("wallet_id") == walletID)
                try tempDB.run(contract.update(Expression<Bool>("wallet_use_state") <- state))
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func updateWalletBackupState(walletID: Int64, state: Bool) -> Bool {
        let walletTable = Table("Wallet")
        do {
            if let tempDB = self.db {
                let contract = walletTable.filter(Expression<Int64>("wallet_id") == walletID)
                try tempDB.run(contract.update(Expression<Bool>("wallet_backup_state") <- state))
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func updateWalletBackupState(wallet: WalletManager) -> Bool {
        let walletTable = Table("Wallet")
        do {
            if let tempDB = self.db {
                let contract = walletTable.filter(Expression<Int64>("wallet_id") == wallet.walletID ?? 9999)

                try tempDB.run(contract.update(Expression<Bool>("wallet_backup_state") <- true))
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func userExistInLocal(walletID: Int64) -> Bool {
        let walletTable = Table("Wallet")
        do {
            if let tempDB = self.db {
                let transection = walletTable.filter(Expression<Int64>("wallet_id") == walletID)
                let count = try tempDB.scalar(transection.count)
                if count == 0 {
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func deleteHDWallet() {
        let walletTable = Table("Wallet")
        do {
            if let tempDB = self.db {
                let rowid = try tempDB.run(walletTable.delete())
                print(rowid)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
extension DataBaseManager {
    func createTransferAddressListTable() {
        /// 判断是否存在表
        guard isExistTable(name: "TransferAddress") == false else {
            return
        }
        do {
            let addressTable = Table("TransferAddress")
            // 设置字段
            let addressID = Expression<Int64>("address_id")
            // 地址名字
            let addressName = Expression<String>("address_name")
            // 地址
            let address = Expression<String>("address")
            // 地址类型(0=Libra、1=Violas、2=BTC)
            let addressType = Expression<String>("address_type")
            
            // 建表
            try db!.run(addressTable.create { t in
                t.column(addressID, primaryKey: true)
                t.column(addressName)
                t.column(address, unique: true)
                t.column(addressType)
            })
        } catch {
            let errorString = error.localizedDescription
            if errorString.hasSuffix("already exists") == true {
                return
            } else {
                print(errorString)
            }
        }
    }
    func insertTransferAddress(model: AddressModel) -> Bool {
        let addressTable = Table("TransferAddress")
        do {
            if let tempDB = self.db {
                let insert = addressTable.insert(
                    
                    Expression<String>("address_name") <- model.addressName ?? "",
                    Expression<String>("address") <- "\(model.addressType!)_" + (model.address ?? ""),
                    Expression<String>("address_type") <- model.addressType ?? "")
                
                let rowid = try tempDB.run(insert)
                print(rowid)
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func getTransferAddress(type: String) -> NSMutableArray {
        let addressTable = type.isEmpty == true ? Table("TransferAddress") : Table("TransferAddress").filter(Expression<String>("address_type") == type)
        do {
            if let tempDB = self.db {
                let addressArray = NSMutableArray()
                for wallet in try tempDB.prepare(addressTable) {
                    // 地址ID
                    let addressID = wallet[Expression<Int64>("address_id")]
                    // 地址名字
                    let addressName = wallet[Expression<String>("address_name")]
                    // 地址
                    let address = wallet[Expression<String>("address")]
                    // 地址类型(0=Libra、1=Violas、2=BTC)
                    let addressType = wallet[Expression<String>("address_type")]

                    let contentArray = address.split(separator: "_").compactMap { (item) -> String in
                        return "\(item)"
                    }
                    guard contentArray.count == 2 else {
                        continue
                    }
                    let model = AddressModel.init(addressID: addressID,
                                                  address: contentArray.last,
                                                  addressName: addressName,
                                                  addressType: addressType)

                    addressArray.add(model)
                }
                return addressArray
            } else {
                return NSMutableArray()
            }
        } catch {
            print(error.localizedDescription)
            return NSMutableArray()
        }
    }
    func updateTransferAddressName(model: AddressModel, name: String) -> Bool {
        let addressTable = Table("TransferAddress")
        do {
            if let tempDB = self.db {
                let item = addressTable.filter(Expression<String>("address") == model.address!)
                try tempDB.run(item.update(Expression<String>("address_name") <- name))
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func deleteTransferAddressFromTable(model: AddressModel) -> Bool {
        let transectionAddressHistoryTable = Table("TransferAddress")
        do {
            if let tempDB = self.db {
                let contract = transectionAddressHistoryTable.filter(Expression<String>("address") == "\(model.addressType!)_" + model.address!)
                let rowid = try tempDB.run(contract.delete())
                print(rowid)
                if rowid == 0 {
                    return false
                }
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
// MARK: 创建ViolasToken表
extension DataBaseManager {
    func createViolasTokenTable() {
        /// 判断是否存在表
        guard isExistTable(name: "Tokens") == false else {
            return
        }
        guard let tempDB = self.db else {
            return
        }
        do {
            let tokenTable = Table("Tokens")
            // 币ID
            let tokenID = Expression<Int64>("token_id")
            // 币名字
            let tokenName = Expression<String>("token_name")
            // 币地址
            let tokenAddress = Expression<String>("token_address")
            // 币金额
            let tokenBalance = Expression<Int64>("token_balance")
            // 币授权Key
            let tokenAuthenticationKey = Expression<String>("token_authentication_key")
            // 币激活状态
            let walletActiveState = Expression<Bool>("token_active_state")
            // 币类型(0=Libra、1=Violas、2=BTC)
            let tokenType = Expression<Int64>("token_type")
            // 币当前使用层数
            let tokenIndex = Expression<Int64>("token_index")
            // 币合约地址
            let tokenContract = Expression<String>("token_contract")
            // 币合约名称
            let tokenModule = Expression<String>("token_module")
            // 币合约名称
            let tokenModuleName = Expression<String>("token_module_name")
            // 币启用状态
            let tokenEnable = Expression<Bool>("token_enable")
            // 币图片
            let tokenIcon = Expression<String>("token_icon")
            // 币价
            let tokenPrice = Expression<String>("token_price")
            // 建表
            try tempDB.run(tokenTable.create { t in
                t.column(tokenID, primaryKey: true)
                t.column(tokenName)
                t.column(tokenAddress)
                t.column(tokenBalance)
                t.column(tokenAuthenticationKey)
                t.column(walletActiveState)
                t.column(tokenType)
                t.column(tokenIndex)
                t.column(tokenContract)
                t.column(tokenModule)
                t.column(tokenModuleName)
                t.column(tokenEnable)
                t.column(tokenIcon)
                t.column(tokenPrice)
                t.unique([tokenAddress, tokenModule, tokenType])
            })
        } catch {
            let errorString = error.localizedDescription
            if errorString.hasSuffix("already exists") == true {
                return
            } else {
                print(errorString)
            }
        }
    }
    func insertToken(token: Token) -> Bool {
        let addressTable = Table("Tokens")
        do {
            if let tempDB = self.db {
                let insert = addressTable.insert(
                    // 币名字
                    Expression<String>("token_name") <- token.tokenName,
                    // 币地址
                    Expression<String>("token_address") <- token.tokenAddress,
                    // 币金额
                    Expression<Int64>("token_balance") <- token.tokenBalance,
                    // 币授权Key
                    Expression<String>("token_authentication_key") <- token.tokenAuthenticationKey,
                    // 币激活状态
                    Expression<Bool>("token_active_state") <- token.tokenActiveState,
                    // 币类型(0=Libra、1=Violas、2=BTC)
                    Expression<Int64>("token_type") <- token.tokenType.value,
                    // 币当前使用层数
                    Expression<Int64>("token_index") <- token.tokenIndex,
                    // 币合约地址
                    Expression<String>("token_contract") <- token.tokenContract,
                    // 币合约名称
                    Expression<String>("token_module") <- token.tokenModule,
                    // 币合约名称
                    Expression<String>("token_module_name") <- token.tokenModuleName,
                    // 币启用状态
                    Expression<Bool>("token_enable") <- token.tokenEnable,
                    // 币图片
                    Expression<String>("token_icon") <- token.tokenIcon,
                    // 币价
                    Expression<String>("token_price") <- token.tokenPrice)
                let rowid = try tempDB.run(insert)
                print(rowid)
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func isExistViolasToken(tokenAddress: String, tokenModule: String, tokenType: WalletType) -> Bool {
        let walletTable = Table("Tokens")
        do {
            if let tempDB = self.db {
                let transection = walletTable.filter(Expression<String>("token_address") == tokenAddress && Expression<String>("token_module") == tokenModule && Expression<Int64>("token_type") == tokenType.value)
                let count = try tempDB.scalar(transection.count)
                guard count != 0 else {
                    return false
                }
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func getTokens() throws -> [Token] {
        let walletTable = Table("Tokens")
        do {
            if let tempDB = self.db {
                var models = [Token]()
                let table = walletTable.filter(Expression<Bool>("token_enable") == true)
                for wallet in try tempDB.prepare(table) {
                    // 币ID
                    let tokenID = wallet[Expression<Int64>("token_id")]
                    // 币名字
                    let tokenName = wallet[Expression<String>("token_name")]
                    // 币地址
                    let tokenAddress = wallet[Expression<String>("token_address")]
                    // 币金额
                    let tokenBalance = wallet[Expression<Int64>("token_balance")]
                    // 币授权Key
                    let tokenAuthenticationKey = wallet[Expression<String>("token_authentication_key")]
                    // 币激活状态
                    let walletActiveState = wallet[Expression<Bool>("token_active_state")]
                    // 币类型(0=Libra、1=Violas、2=BTC)
                    let tokenType = wallet[Expression<Int64>("token_type")]
                    // 币当前使用层数
                    let tokenIndex = wallet[Expression<Int64>("token_index")]
                    // 币合约地址
                    let tokenContract = wallet[Expression<String>("token_contract")]
                    // 币合约名称
                    let tokenModule = wallet[Expression<String>("token_module")]
                    // 币合约名称
                    let tokenModuleName = wallet[Expression<String>("token_module_name")]
                    // 币启用状态
                    let tokenEnable = wallet[Expression<Bool>("token_enable")]
                    // 币图片
                    let tokenIcon = wallet[Expression<String>("token_icon")]
                    // 币价
                    let tokenPrice = wallet[Expression<String>("token_price")]
                    let type: WalletType
                    if tokenType == 0 {
                        type = .Libra
                    } else if tokenType == 1 {
                        type = .Violas
                    } else {
                        type = .BTC
                    }
                    
                    let wallet = Token.init(tokenID: tokenID,
                                            tokenName: tokenName,
                                            tokenBalance: tokenBalance,
                                            tokenAddress: tokenAddress,
                                            tokenType: type,
                                            tokenIndex: tokenIndex,
                                            tokenAuthenticationKey: tokenAuthenticationKey,
                                            tokenActiveState: walletActiveState,
                                            tokenIcon: tokenIcon,
                                            tokenContract: tokenContract,
                                            tokenModule: tokenModule,
                                            tokenModuleName: tokenModuleName,
                                            tokenEnable: tokenEnable,
                                            tokenPrice: tokenPrice)
                    models.append(wallet)
                }
                return models
            } else {
                throw LibraWalletError.error("读取数据库失败")
            }
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
//    func deleteViolasToken(walletID: Int64, address: String, tokenNumber: Int64) -> Bool {
//        let violasTokenTable = Table("Tokens")
//        do {
//            if let tempDB = self.db {
//                let contract = violasTokenTable.filter(Expression<String>("token_address") == address && Expression<Int64>("token_binding_wallet_id") == walletID && Expression<Int64>("token_number") == tokenNumber)
//                let rowid = try tempDB.run(contract.delete())
//                print(rowid)
//                return true
//            } else {
//                return false
//            }
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
//    }
    func updateViolasTokenState(tokenAddress: String, tokenModule: String, tokenType: WalletType, state: Bool) -> Bool {
        let violasTokenTable = Table("Tokens")
        do {
            if let tempDB = self.db {
                let item = violasTokenTable.filter(Expression<String>("token_address") == tokenAddress && Expression<String>("token_module") == tokenModule && Expression<Int64>("token_type") == tokenType.value)
                try tempDB.run(item.update(Expression<Bool>("token_enable") <- state))
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func updateTokenBalance(tokenID: Int64, balance: Int64) -> Bool {
        let violasTokenTable = Table("Tokens")
        do {
            if let tempDB = self.db {
                let item = violasTokenTable.filter(Expression<Int64>("token_id") == tokenID)
                try tempDB.run(item.update(Expression<Int64>("token_balance") <- balance))
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func updateTokenBalance(tokenID: Int64, model: Token) -> Bool {
        let violasTokenTable = Table("Tokens")
        do {
            if let tempDB = self.db {
                let item = violasTokenTable.filter(Expression<Int64>("token_id") == tokenID)
                try tempDB.run(item.update(Expression<Int64>("token_balance") <- model.tokenBalance))
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func updateTokenActiveState(tokenID: Int64, state: Bool) -> Bool {
        let walletTable = Table("Tokens")
        do {
            if let tempDB = self.db {
                let contract = walletTable.filter(Expression<Int64>("token_id") == tokenID)
                try tempDB.run(contract.update(Expression<Bool>("token_active_state") <- state))
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func updateTokenPrice(tokenID: Int64, price: String) -> Bool {
        let walletTable = Table("Tokens")
        do {
            if let tempDB = self.db {
                let contract = walletTable.filter(Expression<Int64>("token_id") == tokenID)
                try tempDB.run(contract.update(Expression<String>("token_price") <- price))
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
//let transection = walletTable.filter(Expression<String>("wallet_mnemonic_hash") == wallet.walletMnemonicHash && Expression<String>("wallet_contract") == wallet.walletContract && Expression<Int>("wallet_type") == wallet.walletType.value)
