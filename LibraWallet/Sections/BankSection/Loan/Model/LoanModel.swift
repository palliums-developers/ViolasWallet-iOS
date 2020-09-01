//
//  LoanModel.swift
//  LibraWallet
//
//  Created by wangyingdong on 2020/8/26.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit
import Moya
struct BankLoanMarketDataIntroduceModel: Codable {
    var text: String?
    var tital: String?
    /// 高度（自行添加）
    var height: CGFloat?
}
struct BankLoanMarketDataModel: Codable {
    /// 产品ID
    var id: String?
    /// 产品说明
    var intor: [BankLoanMarketDataIntroduceModel]?
    /// 产品最少借贷额度
    var minimum_amount: UInt64?
    /// 产品名称
    var name: String?
    /// 质押率
    var pledge_rate: Double?
    /// 常见问题
    var question: [BankLoanMarketDataIntroduceModel]?
    /// 可借额度
    var quota_limit: UInt64?
    /// 可借额度已使用
    var quota_used: UInt64?
    /// 借贷率
    var rate: Double?
    /// 借贷币地址
    var token_address: String?
    /// 借贷币Module
    var token_module: String?
    /// 借贷币Name
    var token_name: String?
    /// 借贷币展示名字
    var token_show_name: String?
    /// 借贷币图片
    var logo: String?
    /// 余额（自行添加）
    var token_balance: Int64?
    /// 激活状态（自行添加）
    var token_active_state: Bool?
}
struct LoanItemDetailMainModel: Codable {
    var code: Int?
    var message: String?
    var data: BankLoanMarketDataModel?
}
class LoanModel: NSObject {
    private var requests: [Cancellable] = []
    @objc dynamic var dataDic: NSMutableDictionary = [:]
    private var loanItemModel: DepositItemDetailMainDataModel?
    private var sequenceNumber: UInt64?

    deinit {
        requests.forEach { cancellable in
            cancellable.cancel()
        }
        requests.removeAll()
        print("DepositModel销毁了")
    }
    func getLocalModel(model: BankLoanMarketDataModel? = nil) -> [DepositLocalDataModel] {
        
        return [DepositLocalDataModel.init(title: localLanguage(keyString: "wallet_bank_loan_year_rate_title"),
                                           titleDescribe: "",
                                           content: model != nil ? (NSDecimalNumber.init(value: model?.rate ?? 0).multiplying(by: NSDecimalNumber.init(value: 100)).stringValue + "%"):"---",
                                           contentColor: "13B788",
                                           conentFont: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)),
                DepositLocalDataModel.init(title: localLanguage(keyString: "wallet_bank_loan_pledge_rate_title"),
                                           titleDescribe: localLanguage(keyString: "wallet_bank_loan_pledge_rate_descript_title"),
                                           content: model != nil ? (NSDecimalNumber.init(value: model?.pledge_rate ?? 0).multiplying(by: NSDecimalNumber.init(value: 100)).stringValue + "%"):"---",
                                           contentColor: "333333",
                                           conentFont: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)),
                DepositLocalDataModel.init(title: localLanguage(keyString: "wallet_bank_loan_pay_account_title"),
                                           titleDescribe: "",
                                           content: localLanguage(keyString: "wallet_bank_loan_pay_account_content"),
                                           contentColor: "333333",
                                           conentFont: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular))]
    }
    func getLoanItemDetail(itemID: String, address: String) {
        let request = mainProvide.request(.loanItemDetail(itemID, address)) {[weak self](result) in
            switch  result {
            case let .success(response):
                do {
                    let json = try response.map(LoanItemDetailMainModel.self)
                    if json.code == 2000 {
                        guard let model = json.data else {
                            let data = setKVOData(error: LibraWalletError.WalletRequest(reason: LibraWalletError.RequestError.dataEmpty), type: "GetLoanItemDetail")
                            self?.setValue(data, forKey: "dataDic")
                            print("GetLoanItemDetail_状态异常")
                            return
                        }
                        let data = setKVOData(type: "GetLoanItemDetail", data: model)
                        self?.setValue(data, forKey: "dataDic")
                    } else {
                        print("GetLoanItemDetail_状态异常")
                        if let message = json.message, message.isEmpty == false {
                            let data = setKVOData(error: LibraWalletError.error(message), type: "GetLoanItemDetail")
                            self?.setValue(data, forKey: "dataDic")
                        } else {
                            let data = setKVOData(error: LibraWalletError.WalletRequest(reason: LibraWalletError.RequestError.dataCodeInvalid), type: "GetLoanItemDetail")
                            self?.setValue(data, forKey: "dataDic")
                        }
                    }
                } catch {
                    print("GetLoanItemDetail_解析异常\(error.localizedDescription)")
                    let data = setKVOData(error: LibraWalletError.WalletRequest(reason: LibraWalletError.RequestError.parseJsonError), type: "GetLoanItemDetail")
                    self?.setValue(data, forKey: "dataDic")
                }
            case let .failure(error):
                guard error.errorCode != -999 else {
                    print("GetLoanItemDetail_网络请求已取消")
                    return
                }
                let data = setKVOData(error: LibraWalletError.WalletRequest(reason: .networkInvalid), type: "GetLoanItemDetail")
                self?.setValue(data, forKey: "dataDic")
            }
        }
        self.requests.append(request)
    }
}
extension LoanModel {
    func sendLoanTransaction(sendAddress: String, amount: UInt64, fee: UInt64, mnemonic: [String], module: String, feeModule: String, activeState: Bool) {
        let semaphore = DispatchSemaphore.init(value: 1)
        let queue = DispatchQueue.init(label: "SendQueue")
        if activeState == false {
            queue.async {
                semaphore.wait()
                self.getViolasSequenceNumber(sendAddress: sendAddress, semaphore: semaphore)
            }
            queue.async {
                semaphore.wait()
                do {
                    let signature = try ViolasManager.getPublishTokenTransactionHex(mnemonic: mnemonic,
                                                                                    fee: 0,
                                                                                    sequenceNumber: self.sequenceNumber ?? 0,
                                                                                    inputModule: module)
                    self.makeViolasTransaction(signature: signature, type: "SendPublishOutputModuleViolasTransaction", semaphore: semaphore)
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async(execute: {
                        let data = setKVOData(error: LibraWalletError.error(error.localizedDescription), type: "SendPublishOutputModuleViolasTransaction")
                        self.setValue(data, forKey: "dataDic")
                    })
                }
            }
        }
        queue.async {
            semaphore.wait()
            self.getViolasSequenceNumber(sendAddress: sendAddress, semaphore: semaphore)
        }
        queue.async {
            semaphore.wait()
            do {
//                let signature = try ViolasManager.getMarketSwapTransactionHex(sendAddress: sendAddress,
//                                                                              mnemonic: mnemonic,
//                                                                              feeModule: feeModule,
//                                                                              fee: 1,
//                                                                              sequenceNumber: self.sequenceNumber ?? 0,
//                                                                              inputAmount: amount,
//                                                                              outputAmountMin: AmountOutMin,
//                                                                              path: path,
//                                                                              inputModule: moduleA,
//                                                                              outputModule: moduleB)
//                self.makeViolasTransaction(signature: signature, type: "SendViolasTransaction")
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async(execute: {
                    let data = setKVOData(error: LibraWalletError.error(error.localizedDescription), type: "SendViolasTransaction")
                    self.setValue(data, forKey: "dataDic")
                })
            }
            semaphore.signal()
        }
    }
    private func getViolasSequenceNumber(sendAddress: String, semaphore: DispatchSemaphore) {
        let request = mainProvide.request(.GetViolasAccountInfo(sendAddress)) {[weak self](result) in
            switch  result {
            case let .success(response):
                do {
                    let json = try response.map(BalanceViolasMainModel.self)
                    if json.error == nil {
                        self?.sequenceNumber = json.result?.sequence_number ?? 0
                        semaphore.signal()
                    } else {
                        print("GetViolasSequenceNumber_状态异常")
                        DispatchQueue.main.async(execute: {
                            if let message = json.error?.message, message.isEmpty == false {
                                let data = setKVOData(error: LibraWalletError.error(message), type: "GetViolasSequenceNumber")
                                self?.setValue(data, forKey: "dataDic")
                            } else {
                                let data = setKVOData(error: LibraWalletError.WalletRequest(reason: LibraWalletError.RequestError.dataCodeInvalid), type: "SendLibraTransaction")
                                self?.setValue(data, forKey: "dataDic")
                            }
                        })
                    }
                } catch {
                    print("GetViolasSequenceNumber_解析异常\(error.localizedDescription)")
                    DispatchQueue.main.async(execute: {
                        let data = setKVOData(error: LibraWalletError.WalletRequest(reason: LibraWalletError.RequestError.parseJsonError), type: "GetViolasSequenceNumber")
                        self?.setValue(data, forKey: "dataDic")
                    })
                }
            case let .failure(error):
                guard error.errorCode != -999 else {
                    print("GetViolasSequenceNumber_网络请求已取消")
                    return
                }
                DispatchQueue.main.async(execute: {
                    let data = setKVOData(error: LibraWalletError.WalletRequest(reason: .networkInvalid), type: "GetViolasSequenceNumber")
                    self?.setValue(data, forKey: "dataDic")
                })
            }
        }
        self.requests.append(request)
    }
    private func makeViolasTransaction(signature: String, type: String, semaphore: DispatchSemaphore? = nil) {
        let request = mainProvide.request(.SendViolasTransaction(signature)) {[weak self](result) in
            switch  result {
            case let .success(response):
                do {
                    let json = try response.map(LibraTransferMainModel.self)
                    if json.result == nil {
                        DispatchQueue.main.async(execute: {
                            if let sema = semaphore {
                                sema.signal()
                            } else {
                                let data = setKVOData(type: type)
                                self?.setValue(data, forKey: "dataDic")
                            }
                        })
                    } else {
                        print("\(type)_状态异常")
                        DispatchQueue.main.async(execute: {
                            if let message = json.error?.message, message.isEmpty == false {
                                let data = setKVOData(error: LibraWalletError.error(message), type: type)
                                self?.setValue(data, forKey: "dataDic")
                            } else {
                                let data = setKVOData(error: LibraWalletError.WalletRequest(reason: LibraWalletError.RequestError.dataCodeInvalid), type: type)
                                self?.setValue(data, forKey: "dataDic")
                            }
                        })
                    }
                } catch {
                    print("\(type)_解析异常\(error.localizedDescription)")
                    DispatchQueue.main.async(execute: {
                        let data = setKVOData(error: LibraWalletError.WalletRequest(reason: LibraWalletError.RequestError.parseJsonError), type: type)
                        self?.setValue(data, forKey: "dataDic")
                    })
                }
            case let .failure(error):
                guard error.errorCode != -999 else {
                    print("\(type)_网络请求已取消")
                    return
                }
                DispatchQueue.main.async(execute: {
                    let data = setKVOData(error: LibraWalletError.WalletRequest(reason: .networkInvalid), type: type)
                    self?.setValue(data, forKey: "dataDic")
                })
                
            }
        }
        self.requests.append(request)
    }

}
