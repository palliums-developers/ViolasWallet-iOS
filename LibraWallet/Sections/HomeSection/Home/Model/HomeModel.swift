//
//  HomeModel.swift
//  LibraWallet
//
//  Created by palliums on 2019/9/11.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit
import SwiftGRPC
import Moya

struct BalanceLibraModel: Codable {
    /// 余额
    var balance: Int64?
    /// 地址
    var address: String?
}
struct BalanceLibraMainModel: Codable {
    /// 错误代码
    var code: Int?
    /// 错误信息
    var message: String?
    /// 数据体
    var data: BalanceLibraModel?
}

struct BalanceBTCModel: Codable {
    /// 地址
    var address: String?
    /// 总接收
    var received: Int?
    /// 总支出
    var sent: Int?
    /// 当前余额
    var balance: Int64?
    /// 交易数量
    var tx_count: Int?
    /// 未确认交易数量
    var unconfirmed_tx_count: Int?
    /// 未确认总接收
    var unconfirmed_received: Int?
    /// 未确认总支出
    var unconfirmed_sent: Int?
    /// 未花费交易数量D
    var unspent_tx_count: Int?
    /// 第一笔交易
    var first_tx: String?
    /// 最后一笔交易
    var last_tx: String?
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let tempAmount = try container.decode(Int64.self)
//        balance = tempAmount / 100000000
//    }
}
struct BalanceBTCMainModel: Codable {
    var err_no: Int?
    var data: BalanceBTCModel?
}
class HomeModel: NSObject {
    private var requests: [Cancellable] = []
    @objc var dataDic: NSMutableDictionary = [:]
    func getLocalUserInfo() {
        do {
            let wallet = try DataBaseManager.DBManager.getCurrentUseWallet()
            let data = setKVOData(type: "LoadCurrentUseWallet", data: wallet)
            self.setValue(data, forKey: "dataDic")
            guard let address = wallet.walletAddress else {
                return
            }
            guard let walletID = wallet.walletID else {
                return
            }
            // 更新本地数据
            switch wallet.walletType {
            case .Libra:
                tempGetLibraBalance(walletID: walletID, address: address)
                break
            case .Violas:
                getViolasBalance(walletID: walletID, address: address)
                break
            case .BTC:
                getBTCBalance(walletID: walletID, address: address)
                break
            default:
                break
            }
//            updateLocalInfo(walletAddress: LibraWalletManager.shared.walletAddress!)
        } catch {
            
        }
    }
    func updateLocalWalletData(walletID: Int64, balance: Int64) {
        // 更新内存中数据
//        LibraWalletManager.shared.changeWalletBalance(banlance: model.balance ?? 0)
        
        // 刷新本地缓存数据
        _ = DataBaseManager.DBManager.updateWalletBalance(walletID: walletID, balance: balance)
    }
    func tempGetLibraBalance(walletID: Int64, address: String) {
        let quene = DispatchQueue.init(label: "createWalletQuene")
        quene.async {
            let channel = Channel.init(address: libraMainURL, secure:  false)
            
            let client = AdmissionControl_AdmissionControlServiceClient.init(channel: channel)
            do {
                var request = Types_GetAccountStateRequest()
                request.address = Data.init(hex: address)
                
                var requestItem = Types_RequestItem()
                requestItem.getAccountStateRequest = request
                
                var Ledger = Types_UpdateToLatestLedgerRequest()
                Ledger.requestedItems = [requestItem]
                
                let gaaa = try client.updateToLatestLedger(Ledger)
                
                guard let response = gaaa.responseItems.first else {
                    return
                }
                let streamData = response.getAccountStateResponse.accountStateWithProof.blob.blob
                
                let balance = LibraAccount.init(accountData: streamData).balance
                DispatchQueue.main.async(execute: {
                    //需更新
                    let model = BalanceLibraModel.init(balance: balance, address: address)
                    let data = setKVOData(type: "UpdateLibraBalance", data: model)
                    self.setValue(data, forKey: "dataDic")
                })
                self.updateLocalWalletData(walletID: walletID, balance: LibraAccount.init(accountData: streamData).balance ?? 0)
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async(execute: {
                    let data = setKVOData(error: LibraWalletError.error(error.localizedDescription), type: "UpdateBTCBalance")
                    self.setValue(data, forKey: "dataDic")
                })
            }
        }
        
    }
    
    func getBTCBalance(walletID: Int64, address: String) {
        let request = mainProvide.request(.GetBTCBalance("mvgsVUUG62L5KMsFx9TCQuMkC2tRb38fFX")) {[weak self](result) in
            switch  result {
            case let .success(response):
                do {
                    let json = try response.map(BalanceBTCMainModel.self)
                    guard json.err_no == 0 else {
                        let data = setKVOData(error: LibraWalletError.WalletRequest(reason: LibraWalletError.RequestError.dataCodeInvalid), type: "UpdateBTCBalance")
                        self?.setValue(data, forKey: "dataDic")
                        return
                    }
                    let data = setKVOData(type: "UpdateBTCBalance", data: json.data)
                    self?.setValue(data, forKey: "dataDic")
                    // 刷新本地数据
                    self?.updateLocalWalletData(walletID: walletID, balance: json.data?.balance ?? 0)
                } catch {
                    print("解析异常\(error.localizedDescription)")
                    let data = setKVOData(error: LibraWalletError.WalletRequest(reason: LibraWalletError.RequestError.parseJsonError), type: "UpdateBTCBalance")
                    self?.setValue(data, forKey: "dataDic")
                }
            case let .failure(error):
                guard error.errorCode != -999 else {
                    print("网络请求已取消")
                    return
                }
                let data = setKVOData(error: LibraWalletError.WalletRequest(reason: .networkInvalid), type: "UpdateBTCBalance")
                self?.setValue(data, forKey: "dataDic")
            }
        }
        self.requests.append(request)
    }
//    func getLibraBalance(walletID: Int64, address: String) {
//        let request = mainProvide.request(.GetLibraAccountBalance(address)) {[weak self](result) in
//            switch  result {
//            case let .success(response):
//                do {
//                    let json = try response.map(BalanceLibraMainModel.self)
//                    let data = setKVOData(type: "GetLibraBalance", data: json.data)
//                    self?.setValue(data, forKey: "dataDic")
//                    // 刷新本地数据
//                    self?.updateLocalWalletData(walletID: walletID, balance: json.data?.balance ?? 0)
//                } catch {
//                    print("解析异常\(error.localizedDescription)")
//                    let data = setKVOData(error: LibraWalletError.WalletRequest(reason: LibraWalletError.RequestError.parseJsonError), type: "GetLibraBalance")
//                    self?.setValue(data, forKey: "dataDic")
//                }
//            case let .failure(error):
//                guard error.errorCode != -999 else {
//                    print("网络请求已取消")
//                    return
//                }
//                let data = setKVOData(error: LibraWalletError.WalletRequest(reason: .networkInvalid), type: "GetLibraBalance")
//                self?.setValue(data, forKey: "dataDic")
//            }
//        }
//        self.requests.append(request)
//    }
    func getViolasBalance(walletID: Int64, address: String) {
        let request = mainProvide.request(.GetViolasAccountBalance(address)) {[weak self](result) in
            switch  result {
            case let .success(response):
                do {
                    let json = try response.map(BalanceLibraMainModel.self)
                    let data = setKVOData(type: "UpdateViolasBalance", data: json.data)
                    self?.setValue(data, forKey: "dataDic")
                    // 刷新本地数据
                    self?.updateLocalWalletData(walletID: walletID, balance: json.data?.balance ?? 0)
                } catch {
                    print("解析异常\(error.localizedDescription)")
                    let data = setKVOData(error: LibraWalletError.WalletRequest(reason: LibraWalletError.RequestError.parseJsonError), type: "UpdateViolasBalance")
                    self?.setValue(data, forKey: "dataDic")
                }
            case let .failure(error):
                guard error.errorCode != -999 else {
                    print("网络请求已取消")
                    return
                }
                let data = setKVOData(error: LibraWalletError.WalletRequest(reason: .networkInvalid), type: "UpdateViolasBalance")
                self?.setValue(data, forKey: "dataDic")
            }
        }
        self.requests.append(request)
    }
    deinit {
        requests.forEach { cancellable in
            cancellable.cancel()
        }
        requests.removeAll()
        print("HomeModel销毁了")
    }
}