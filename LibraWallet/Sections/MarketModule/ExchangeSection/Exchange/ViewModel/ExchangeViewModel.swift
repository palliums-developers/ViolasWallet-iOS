//
//  ExchangeViewModel.swift
//  LibraWallet
//
//  Created by wangyingdong on 2020/8/4.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit
class ExchangeViewModel: NSObject {
    override init() {
        super.init()
    }
    var view: ExchangeView? {
        didSet {
            view?.headerView.delegate = self
            view?.headerView.inputAmountTextField.delegate = self
            view?.headerView.outputAmountTextField.delegate = self
        }
    }
    /// 网络请求、数据模型
    lazy var dataModel: ExchangeModel = {
        let model = ExchangeModel.init()
        return model
    }()
    /// 数据监听KVO
    var observer: NSKeyValueObservation?
    ///
    private var firstRequestRate: Bool = true
    /// timer
    private var timer: Timer?
}
// MARK: - 网络请求逻辑处理
extension ExchangeViewModel {
    func startAutoRefreshExchangeRate(inputCoinA: MarketSupportTokensDataModel, outputCoinB: MarketSupportTokensDataModel) {
        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(refreshExchangeRate), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: .common)
    }
    func stopAutoRefreshExchangeRate() {
        self.timer?.invalidate()
        self.timer = nil
    }
    @objc func refreshExchangeRate() {
        self.dataModel.getPoolTotalLiquidity(inputCoinA: (self.view?.headerView.transferInInputTokenA)!, inputCoinB: (self.view?.headerView.transferInInputTokenB)!)
    }
}
// MARK: - 逻辑处理
extension ExchangeViewModel {
    func handleUnlockWallet(inputAmount: NSDecimalNumber, outputAmount: NSDecimalNumber, inputModule: MarketSupportTokensDataModel, outputModule: MarketSupportTokensDataModel, outputModuleActiveState: Bool) {
        WalletManager.unlockWallet { [weak self] (result) in
            switch result {
            case let .success(mnemonic):
                self?.handleRequest(inputAmount: inputAmount,
                                    outputAmount: outputAmount,
                                    inputModule: inputModule,
                                    outputModule: outputModule,
                                    mnemonic: mnemonic,
                                    outputModuleActiveState: outputModuleActiveState)
            case let .failure(error):
                guard error.localizedDescription != "Cancel" else {
                    self?.view?.toastView?.hide(tag: 99)
                    return
                }
                self?.view?.makeToast(error.localizedDescription, position: .center)
            }
        }
    }
    func handleRequest(inputAmount: NSDecimalNumber, outputAmount: NSDecimalNumber, inputModule: MarketSupportTokensDataModel, outputModule: MarketSupportTokensDataModel, mnemonic: [String], outputModuleActiveState: Bool) {
        if inputModule.chainType == 1 && outputModule.chainType == 1 {
            print("ViolasToViolasSwap")
            self.view?.headerView.viewState = .ViolasToViolasSwap
            self.view?.toastView?.show(tag: 99)
            self.dataModel.sendSwapViolasTransaction(sendAddress: WalletManager.shared.violasAddress ?? "",
                                                     amountIn: inputAmount.uint64Value,
                                                     AmountOutMin: outputAmount.multiplying(by: NSDecimalNumber.init(value: 0.99)).uint64Value,
                                                     path: (self.view?.headerView.exchangeModel?.path)!,
                                                     fee: 1,
                                                     mnemonic: mnemonic,
                                                     moduleA: inputModule.module ?? "",
                                                     moduleB: outputModule.module ?? "",
                                                     feeModule: inputModule.module ?? "",
                                                     outputModuleActiveState: outputModuleActiveState)
        } else if inputModule.chainType == 1 && outputModule.chainType == 0 {
            print("ViolasToLibraSwap")
            self.view?.headerView.viewState = .ViolasToLibraSwap
            self.view?.toastView?.show(tag: 99)
            self.dataModel.sendSwapViolasToLibraTransaction(sendAddress: WalletManager.shared.violasAddress ?? "",
                                                            amountIn: inputAmount.uint64Value,
                                                            AmountOut: outputAmount.multiplying(by: NSDecimalNumber.init(value: 0.99)).uint64Value,
                                                            fee: 0,
                                                            mnemonic: mnemonic,
                                                            moduleInput: inputModule.module ?? "",
                                                            moduleOutput: outputModule.module ?? "",
                                                            feeModule: inputModule.module ?? "",
                                                            receiveAddress: WalletManager.shared.libraAddress ?? "",
                                                            outputModuleActiveState: outputModuleActiveState)
        } else if inputModule.chainType == 1 && outputModule.chainType == 2 {
            print("ViolasToBTCSwap")
            self.view?.headerView.viewState = .ViolasToBTCSwap
            self.view?.toastView?.show(tag: 99)
            self.dataModel.sendSwapViolasToBTCTransaction(sendAddress: WalletManager.shared.violasAddress ?? "",
                                                          amountIn: inputAmount.uint64Value,
                                                          AmountOut: outputAmount.multiplying(by: NSDecimalNumber.init(value: 100)).uint64Value,
                                                          fee: 0,
                                                          mnemonic: mnemonic,
                                                          moduleInput: inputModule.module ?? "",
                                                          feeModule: inputModule.module ?? "",
                                                          receiveAddress: WalletManager.shared.btcAddress ?? "",
                                                          outputModuleActiveState: outputModuleActiveState)
        } else if inputModule.chainType == 0 && outputModule.chainType == 0 {
            print("LibraToLibraSwap暂不支持")
        } else if inputModule.chainType == 0 && outputModule.chainType == 1 {
            print("LibraToViolasSwap")
            self.view?.headerView.viewState = .LibraToViolasSwap
            self.view?.toastView?.show(tag: 99)
            self.dataModel.sendLibraToViolasMappingTransaction(sendAddress: WalletManager.shared.libraAddress ?? "",
                                                               amountIn: inputAmount.uint64Value,
                                                               amountOut: outputAmount.multiplying(by: NSDecimalNumber.init(value: 0.99)).uint64Value,
                                                               fee: 0,
                                                               mnemonic: mnemonic,
                                                               moduleInput: inputModule.module ?? "",
                                                               moduleOutput: outputModule.module ?? "",
                                                               violasReceiveAddress: WalletManager.shared.violasAddress ?? "",
                                                               feeModule: inputModule.module ?? "",
                                                               outputModuleActiveState: outputModuleActiveState)
        } else if inputModule.chainType == 0 && outputModule.chainType == 2 {
            print("LibraToBTCSwap暂不支持")
            self.view?.headerView.viewState = .LibraToBTCSwap
        } else if inputModule.chainType == 2 && outputModule.chainType == 0 {
            print("BTCToLibraSwap")
            self.view?.headerView.viewState = .BTCToLibraSwap
            self.view?.toastView?.show(tag: 99)
            let wallet = try! BTCManager().getWallet(mnemonic: mnemonic)
            self.dataModel.makeTransaction(wallet: wallet,
                                           amountIn: inputAmount.multiplying(by: NSDecimalNumber.init(value: 100)).uint64Value,
                                           amountOut: outputAmount.multiplying(by: NSDecimalNumber.init(value: 0.99)).uint64Value,
                                           fee: 0.0002,
                                           mnemonic: mnemonic,
                                           moduleOutput: outputModule.module ?? "",
                                           mappingReceiveAddress: WalletManager.shared.libraAddress ?? "",
                                           outputModuleActiveState: outputModuleActiveState,
                                           chainType: "libra")
        } else if inputModule.chainType == 2 && outputModule.chainType == 1 {
            print("BTCToViolasSwap")
            self.view?.headerView.viewState = .BTCToViolasSwap
            self.view?.toastView?.show(tag: 99)
            let wallet = try! BTCManager().getWallet(mnemonic: mnemonic)
            self.dataModel.makeTransaction(wallet: wallet,
                                           amountIn: inputAmount.multiplying(by: NSDecimalNumber.init(value: 100)).uint64Value,
                                           amountOut: outputAmount.multiplying(by: NSDecimalNumber.init(value: 0.99)).uint64Value,
                                           fee: 0.0002,
                                           mnemonic: mnemonic,
                                           moduleOutput: outputModule.module ?? "",
                                           mappingReceiveAddress: WalletManager.shared.libraAddress ?? "",
                                           outputModuleActiveState: outputModuleActiveState,
                                           chainType: "violas")
        }
    }
    #warning("以后启用")
//    func handleConfirmCondition() throws -> (NSDecimalNumber, NSDecimalNumber, MarketSupportTokensDataModel, MarketSupportTokensDataModel) {
//        // ModelA不为空
//        guard let tempInputTokenA = self.view?.headerView.transferInInputTokenA else {
//            throw LibraWalletError.error(localLanguage(keyString: "wallet_market_exchange_input_token_unselect"))
//        }
//        // ModelB不为空
//        guard let tempInputTokenB = self.view?.headerView.transferInInputTokenB else {
//            throw LibraWalletError.error(localLanguage(keyString: "wallet_market_exchange_output_token_unselect"))
//        }
//        // 付出币激活状态
//        guard let tokenAActiveState = tempInputTokenA.activeState, tokenAActiveState == true else {
//            throw LibraWalletError.error(localLanguage(keyString: "wallet_market_exchange_input_token_unactived"))
//        }
//        // 金额不为空检查
//        guard let amountAString = self.view?.headerView.inputAmountTextField.text, amountAString.isEmpty == false else {
//            throw LibraWalletError.WalletTransfer(reason: .amountEmpty)
//
//        }
//        // 金额是否纯数字检查
//        guard isPurnDouble(string: amountAString) == true else {
//            throw LibraWalletError.WalletTransfer(reason: .amountInvalid)
//        }
//        // 转换数字
//        let amountIn = NSDecimalNumber.init(string: amountAString)
//
//        // 金额不为空检查
//        guard let amountBString = self.view?.headerView.outputAmountTextField.text, amountBString.isEmpty == false else {
//            throw LibraWalletError.WalletTransfer(reason: .amountEmpty)
//        }
//        // 金额是否纯数字检查
//        guard isPurnDouble(string: amountBString) == true else {
//            throw LibraWalletError.WalletTransfer(reason: .amountInvalid)
//        }
//        // 转换数字
//        let amountOut = NSDecimalNumber.init(string: amountBString)
//        guard amountIn.int64Value > 0 else {
//            throw LibraWalletError.WalletTransfer(reason: .amountInvalid)
//        }
//        guard amountOut.int64Value > 0 else {
//            throw LibraWalletError.WalletTransfer(reason: .amountInvalid)
//        }
//        // 金额超限检测
//        guard amountIn.multiplying(by: NSDecimalNumber.init(value: 1000000)).int64Value < (tempInputTokenA.amount ?? 0) else {
//            throw LibraWalletError.WalletTransfer(reason: .amountOverload)
//        }
//        // 金额超限检测
//        guard amountOut.multiplying(by: NSDecimalNumber.init(value: 1000000)).int64Value < (tempInputTokenB.amount ?? 0) else {
//            throw LibraWalletError.WalletTransfer(reason: .amountOverload)
//        }
//        return (amountIn, amountOut, tempInputTokenA, tempInputTokenB)
//    }
}
// MARK: - HeaderView代理逻辑
extension ExchangeViewModel: ExchangeViewHeaderViewDelegate {
    func exchangeConfirm() {
        // ModelA不为空
        guard let tempInputTokenA = self.view?.headerView.transferInInputTokenA else {
            self.view?.makeToast(localLanguage(keyString: "wallet_market_exchange_input_token_unselect"),
                                 position: .center)
            return
        }
        // ModelB不为空
        guard let tempInputTokenB = self.view?.headerView.transferInInputTokenB else {
            self.view?.makeToast(localLanguage(keyString: "wallet_market_exchange_output_token_unselect"),
                                 position: .center)
            return
        }
        // 付出币激活状态
        guard let tokenAActiveState = tempInputTokenA.activeState, tokenAActiveState == true else {
            self.view?.makeToast(LibraWalletError.error(localLanguage(keyString: "wallet_market_exchange_input_token_unactived")).localizedDescription,
                                 position: .center)
            return
        }
        // 金额不为空检查
        guard let amountAString = self.view?.headerView.inputAmountTextField.text, amountAString.isEmpty == false else {
            self.view?.makeToast(LibraWalletError.WalletTransfer(reason: .amountEmpty).localizedDescription,
                                 position: .center)
            return
        }
        // 金额是否纯数字检查
        guard isPurnDouble(string: amountAString) == true else {
            self.view?.makeToast(LibraWalletError.WalletTransfer(reason: .amountInvalid).localizedDescription,
                                 position: .center)
            return
        }
        // 转换数字
        let amountIn = NSDecimalNumber.init(string: amountAString)
        
        // 金额不为空检查
        guard let amountBString = self.view?.headerView.outputAmountTextField.text, amountBString.isEmpty == false else {
            self.view?.makeToast(LibraWalletError.WalletTransfer(reason: .amountEmpty).localizedDescription,
                                 position: .center)
            return
        }
        // 金额是否纯数字检查
        guard isPurnDouble(string: amountBString) == true else {
            self.view?.makeToast(LibraWalletError.WalletTransfer(reason: .amountInvalid).localizedDescription,
                                 position: .center)
            return
        }
        // 转换数字
        let amountOut = NSDecimalNumber.init(string: amountBString)
        guard amountIn.doubleValue > 0 else {
            self.view?.makeToast(LibraWalletError.WalletTransfer(reason: .amountInvalid).localizedDescription,
                                 position: .center)
            return
        }
        guard amountOut.doubleValue > 0 else {
            self.view?.makeToast(LibraWalletError.WalletTransfer(reason: .amountInvalid).localizedDescription,
                                 position: .center)
            return
        }
        // 金额超限检测
        guard amountIn.multiplying(by: NSDecimalNumber.init(value: 1000000)).int64Value < (tempInputTokenA.amount ?? 0) else {
            self.view?.makeToast(LibraWalletError.WalletTransfer(reason: .amountOverload).localizedDescription,
                                 position: .center)
            return
        }
        // 金额超限检测
//        guard amountOut.multiplying(by: NSDecimalNumber.init(value: 1000000)).int64Value < (tempInputTokenB.amount ?? 0) else {
//            self.view?.makeToast(LibraWalletError.WalletTransfer(reason: .amountOverload).localizedDescription,
//                                 position: .center)
//            return
//        }
        
        var leastModuleA = tempInputTokenA
        var otherModuleB = tempInputTokenB
        if (tempInputTokenA.index ?? 0) > (tempInputTokenB.index ?? 0) {
            if tempInputTokenA.chainType == 1 {
                leastModuleA = tempInputTokenB
                otherModuleB = tempInputTokenA
            }
        }
        if let tokenBActiveState = tempInputTokenB.activeState, tokenBActiveState == true {
            // 已激活
            self.handleUnlockWallet(inputAmount: amountIn.multiplying(by: NSDecimalNumber.init(value: 1000000)),
                                    outputAmount: amountOut.multiplying(by: NSDecimalNumber.init(value: 1000000)),
                                    inputModule: leastModuleA,
                                    outputModule: otherModuleB,
                                    outputModuleActiveState: true)
        } else {
            // 未激活
            let alertContr = UIAlertController(title: localLanguage(keyString: "wallet_alert_delete_address_title"), message: localLanguage(keyString: "wallet_market_exchange_output_token_unactived"), preferredStyle: .alert)
            alertContr.addAction(UIAlertAction(title: localLanguage(keyString: "wallet_alert_delete_address_confirm_button_title"), style: .default){ [weak self] clickHandler in
                self?.handleUnlockWallet(inputAmount: amountIn.multiplying(by: NSDecimalNumber.init(value: 1000000)),
                                        outputAmount: amountOut.multiplying(by: NSDecimalNumber.init(value: 1000000)),
                                        inputModule: leastModuleA,
                                        outputModule: otherModuleB,
                                        outputModuleActiveState: false)
            })
            alertContr.addAction(UIAlertAction(title: localLanguage(keyString: "wallet_alert_delete_address_cancel_button_title"), style: .cancel){ clickHandler in
                NSLog("点击了取消")
            })
            var rootViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
            if let navigationController = rootViewController as? UINavigationController {
                rootViewController = navigationController.viewControllers.first
            }
            if let tabBarController = rootViewController as? UITabBarController {
                rootViewController = tabBarController.selectedViewController
            }
            rootViewController?.present(alertContr, animated: true, completion: nil)
        }
    }
    func MappingBTCToViolasConfirm(amountIn: Double, amountOut: Double, inputModel: MarketSupportTokensDataModel, outputModel: MarketSupportTokensDataModel) {
        self.view?.headerView.inputAmountTextField.resignFirstResponder()
        self.view?.headerView.outputAmountTextField.resignFirstResponder()
    }
    func selectInputToken() {
        self.view?.toastView?.show(tag: 99)
        self.dataModel.getMarketTokens(btcAddress: WalletManager.shared.btcAddress ?? "",
                                       violasAddress: WalletManager.shared.violasAddress ?? "",
                                       libraAddress: WalletManager.shared.libraAddress ?? "")
    }
    
    func selectOutoutToken() {
        print("selectOutoutToken")
        self.view?.toastView?.show(tag: 99)
        self.dataModel.getMarketTokens(btcAddress: WalletManager.shared.btcAddress ?? "",
                                       violasAddress: WalletManager.shared.violasAddress ?? "",
                                       libraAddress: WalletManager.shared.libraAddress ?? "")
    }
    
    func swapInputOutputToken() {
        
    }
    
    func dealTransferOutAmount(inputModule: MarketSupportTokensDataModel, outputModule: MarketSupportTokensDataModel) {
        if self.dataModel.shortPath.isEmpty == true {
            self.view?.toastView?.show(tag: 299)
            if firstRequestRate == true {
                self.refreshExchangeRate()
                firstRequestRate = false
            }
            self.startAutoRefreshExchangeRate(inputCoinA: inputModule, outputCoinB: outputModule)
        } else {
            if let amountString = self.view?.headerView.inputAmountTextField.text, amountString.isEmpty == false {
                guard NSDecimalNumber.init(string: amountString).intValue > 0 else {
                    return
                }
                let amount = NSDecimalNumber.init(string: amountString).multiplying(by: NSDecimalNumber.init(value: 1000000)).int64Value
                self.dataModel.fliterBestOutput(inputAAmount: amount,
                                                inputCoinA: inputModule.index!,
                                                paths: self.dataModel.shortPath)
            }
        }
    }
    
    func fliterBestOutputAmount(inputAmount: Int64) {
        guard inputAmount > 0 else {
            return
        }
        self.dataModel.fliterBestOutput(inputAAmount: inputAmount,
                                        inputCoinA: (self.view?.headerView.transferInInputTokenA?.index)!,
                                        paths: self.dataModel.shortPath)
    }
    
    func fliterBestInputAmount(outputAmount: Int64) {
        guard outputAmount > 0 else {
            return
        }
        if self.view?.headerView.exchangeModel == nil {
            
        }
        self.dataModel.fliterBestInput(outputAAmount: outputAmount,
                                       outputCoinA: (self.view?.headerView.transferInInputTokenB?.index)!,
                                       paths: self.dataModel.shortPath)
    }
}
// MARK: - TextField逻辑
extension ExchangeViewModel: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let content = textField.text else {
            return true
        }
        let textLength = content.count + string.count - range.length
        if textField.tag == 10 {
            if textLength == 0 {
                self.view?.headerView.inputAmountTextField.text = ""
                self.view?.headerView.outputAmountTextField.text = ""
            }
        } else {
            if textLength == 0 {
                self.view?.headerView.inputAmountTextField.text = ""
                self.view?.headerView.outputAmountTextField.text = ""
            }
        }
        if content.contains(".") {
            let firstContent = content.split(separator: ".").first?.description ?? "0"
            if (textLength - firstContent.count) < 8 {
                return handleInputAmount(textField: textField, content: (content.isEmpty == true ? "0":content) + string)
            } else {
                return false
            }
        } else {
            if textLength <= ApplyTokenAmountLengthLimit {
                return handleInputAmount(textField: textField, content: (content.isEmpty == true ? "0":content) + string)
            } else {
                return false
            }
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // 转入
        guard self.view?.headerView.inputTokenButton.titleLabel?.text != localLanguage(keyString: "wallet_market_exchange_input_token_button_title") else {
            textField.resignFirstResponder()
            self.view?.makeToast(localLanguage(keyString: "wallet_market_exchange_input_token_unselect"),
                                 position: .center)
            return false
        }
        guard self.view?.headerView.outputTokenButton.titleLabel?.text != localLanguage(keyString: "wallet_market_exchange_output_token_button_title") else {
            textField.resignFirstResponder()
            self.view?.makeToast(localLanguage(keyString: "wallet_market_exchange_output_token_unselect"),
                                 position: .center)
            return false
        }
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 10 {
            if textField.text?.isEmpty == false {
                self.view?.headerView.viewState = .handleBestOutputAmount
                let amount = NSDecimalNumber.init(string: textField.text ?? "0").multiplying(by: NSDecimalNumber.init(value: 1000000)).int64Value
                self.fliterBestOutputAmount(inputAmount: amount)
            }
        } else {
            if textField.text?.isEmpty == false {
                self.view?.headerView.viewState = .handleBestInputAmount
                let amount = NSDecimalNumber.init(string: textField.text ?? "0").multiplying(by: NSDecimalNumber.init(value: 1000000)).int64Value
                self.fliterBestInputAmount(outputAmount: amount)
            }
        }
        
    }
    func handleInputAmount(textField: UITextField, content: String) -> Bool {
        let amount = NSDecimalNumber.init(string: content).multiplying(by: NSDecimalNumber.init(value: 1000000)).int64Value
        if textField.tag == 10 {
            if amount <= self.view?.headerView.transferInInputTokenA?.amount ?? 0 {
                return true
            } else {
                let amount = getDecimalNumber(amount: NSDecimalNumber.init(value: self.view?.headerView.transferInInputTokenA?.amount ?? 0),
                                              scale: 6,
                                              unit: 1000000)
                textField.text = amount.stringValue
                return false
            }
        } else {
            if amount <= self.view?.headerView.transferInInputTokenB?.amount ?? 0 {
                return true
            } else {
                let amount = getDecimalNumber(amount: NSDecimalNumber.init(value: self.view?.headerView.transferInInputTokenB?.amount ?? 0),
                                              scale: 6,
                                              unit: 1000000)
                textField.text = amount.stringValue
                return false
            }
        }
    }
}
// MARK: - 网络请求
extension ExchangeViewModel {
    func initKVO() {
        self.observer = dataModel.observe(\.dataDic, options: [.new], changeHandler: { [weak self](model, change) in
            guard let dataDic = change.newValue, dataDic.count != 0 else {
                self?.view?.toastView?.hide(tag: 99)
                self?.view?.toastView?.hide(tag: 299)
                self?.view?.hideToastActivity()
                return
            }
            #warning("已修改完成，可拷贝执行")
            if let error = dataDic.value(forKey: "error") as? LibraWalletError {
                // 隐藏请求指示
                self?.view?.hideToastActivity()
                self?.view?.toastView?.hide(tag: 99)
                self?.view?.toastView?.hide(tag: 299)
                self?.view?.toastView?.hide(tag: 399)
                if error.localizedDescription == LibraWalletError.WalletRequest(reason: .networkInvalid).localizedDescription {
                    // 网络无法访问
                    print(error.localizedDescription)
                    self?.view?.makeToast(error.localizedDescription,
                                          position: .center)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .walletVersionExpired).localizedDescription {
                    // 版本太久
                    print(error.localizedDescription)
                    self?.view?.makeToast(error.localizedDescription,
                                          position: .center)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .parseJsonError).localizedDescription {
                    // 解析失败
                    print(error.localizedDescription)
                    self?.view?.makeToast(error.localizedDescription,
                                          position: .center)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .dataCodeInvalid).localizedDescription {
                    print(error.localizedDescription)
                    // 数据状态异常
                    self?.view?.makeToast(error.localizedDescription,
                                          position: .center)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .dataEmpty).localizedDescription {
                    print(error.localizedDescription)
                    // 下拉刷新请求数据为空
                    self?.view?.makeToast(error.localizedDescription,
                                          position: .center)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .noMoreData).localizedDescription {
                    // 上拉请求更多数据为空
                    print(error.localizedDescription)
                } else {
                    self?.view?.makeToast(error.localizedDescription,
                                          position: .center)
                }
                self?.view?.headerView.viewState = .Normal
                return
            }
            let type = dataDic.value(forKey: "type") as! String
            if type == "SupportViolasTokens" {
                guard let datas = dataDic.value(forKey: "data") as? [MarketSupportTokensDataModel] else {
                    return
                }
                var tempData = datas
                if self?.view?.headerView.viewState == .ExchangeSelectAToken {
                    if let selectBModel = self?.view?.headerView.transferInInputTokenB {
                        if self?.view?.headerView.transferInInputTokenB?.chainType == 0 {
                            tempData = tempData.filter {
                                $0.chainType != 0
                            }
                        } else {
                            tempData = tempData.filter {
                                $0.module != selectBModel.module
                            }
                        }
                    }
                } else {
                    if let selectBModel = self?.view?.headerView.transferInInputTokenA {
                        if self?.view?.headerView.transferInInputTokenA?.chainType == 0 {
                            tempData = tempData.filter {
                                $0.chainType != 0
                            }
                        } else {
                            tempData = tempData.filter {
                                $0.module != selectBModel.module
                            }
                        }
                    }
                }
                let alert = MappingTokenListAlert.init(data: tempData) { (model) in
                    print(model)
                    if self?.view?.headerView.viewState == .ExchangeSelectAToken {
                        self?.view?.headerView.transferInInputTokenA = model
                    } else {
                        self?.view?.headerView.transferInInputTokenB = model
                    }
                    self?.view?.headerView.viewState = .Normal
                }
                alert.show(tag: 199)
                alert.showAnimation()
            } else if type == "GetExchangeInfo" {
                guard let tempData = dataDic.value(forKey: "data") as? ExchangeInfoModel else {
                    return
                }
                self?.view?.headerView.exchangeModel = tempData
            } else if type == "SendViolasTransaction" {
                self?.view?.headerView.inputAmountTextField.text = ""
                self?.view?.headerView.outputAmountTextField.text = ""
                self?.view?.makeToast(localLanguage(keyString: "wallet_market_exchange_submit_exchange_successful"), position: .center)
            } else if type == "SendViolasToLibraMappingTransaction" {
                self?.view?.headerView.viewState = .Normal
                self?.view?.headerView.inputAmountTextField.text = ""
                self?.view?.headerView.outputAmountTextField.text = ""
                self?.view?.makeToast(localLanguage(keyString: "wallet_market_exchange_submit_exchange_successful"), position: .center)
            } else if type == "SendLibraToViolasTransaction" {
                self?.view?.headerView.viewState = .Normal
                self?.view?.headerView.inputAmountTextField.text = ""
                self?.view?.headerView.outputAmountTextField.text = ""
                self?.view?.makeToast(localLanguage(keyString: "wallet_market_exchange_submit_exchange_successful"), position: .center)
            } else if type == "SendBTCTransaction" {
                self?.view?.headerView.viewState = .Normal
                self?.view?.headerView.inputAmountTextField.text = ""
                self?.view?.headerView.outputAmountTextField.text = ""
                self?.view?.makeToast(localLanguage(keyString: "wallet_market_exchange_submit_exchange_successful"), position: .center)
            } else if type == "GetPoolTotalLiquidity" {
                print("获取流动性成功")
                self?.view?.toastView?.hide(tag: 299)
                return
            }
            self?.view?.hideToastActivity()
            self?.view?.toastView?.hide(tag: 99)
        })
    }
}