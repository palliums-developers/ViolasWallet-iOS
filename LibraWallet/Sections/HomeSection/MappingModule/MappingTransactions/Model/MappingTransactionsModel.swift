//
//  MappingTransactionsModel.swift
//  LibraWallet
//
//  Created by wangyingdong on 2020/2/18.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit
import Moya
struct MappingTransactionsMainDataModel: Codable {
    ///
    var date: Int?
    ///
    var amount: Int?
    ///
    var status: Int?
    ///
    var address: String?
    ///
    var coin: String?
}
struct MappingTransactionsMainModel: Codable {
    var code: Int?
    var message: String?
    var data: [MappingTransactionsMainDataModel]?
}
class MappingTransactionsModel: NSObject {
    private var requests: [Cancellable] = []
    @objc dynamic var dataDic: NSMutableDictionary = [:]
    func getMappingTransactions(walletAddress: String, page: Int, pageSize: Int, requestType: String, requestStatus: Int) {
        let type = requestStatus == 0 ? "MappingTransactionsOrigin":"MappingTransactionsMore"
        let request = mainProvide.request(.GetMappingTransactions(walletAddress, page, pageSize, requestType)) {[weak self](result) in
            switch  result {
            case let .success(response):
                do {
                    let json = try response.map(MappingTransactionsMainModel.self)
                    if json.code == 2000 {
                        guard json.data?.isEmpty == false else {
                            let data = setKVOData(error: LibraWalletError.WalletRequest(reason: LibraWalletError.RequestError.dataEmpty), type: type)
                            self?.setValue(data, forKey: "dataDic")
                            return
                        }
                        let data = setKVOData(type: type, data: json.data)
                        self?.setValue(data, forKey: "dataDic")
                    } else {
                        print("\(type)_状态异常")
                        if let message = json.message, message.isEmpty == false {
                            let data = setKVOData(error: LibraWalletError.error(message), type: type)
                            self?.setValue(data, forKey: "dataDic")
                        } else {
                            let data = setKVOData(error: LibraWalletError.WalletRequest(reason: LibraWalletError.RequestError.dataCodeInvalid), type: type)
                            self?.setValue(data, forKey: "dataDic")
                        }
                    }
                } catch {
                    print("解析异常\(error.localizedDescription)")
                    let data = setKVOData(error: LibraWalletError.WalletRequest(reason: LibraWalletError.RequestError.parseJsonError), type: type)
                    self?.setValue(data, forKey: "dataDic")
                }
            case let .failure(error):
                guard error.errorCode != -999 else {
                    print("网络请求已取消")
                    return
                }
                let data = setKVOData(error: LibraWalletError.WalletRequest(reason: .networkInvalid), type: type)
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
        print("MappingTransactionsModel销毁了")
    }
}