//
//  YieldFarmingViewController.swift
//  LibraWallet
//
//  Created by wangyingdong on 2020/12/4.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit
import WebKit
import WKWebViewJavascriptBridge

class YieldFarmingViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置标题
//        self.title = localLanguage(keyString: "wallet_private_navigation_title")
        // 加载子View
        self.view.addSubview(detailView)
        
//        let request = URLRequest.init(url: URL(string: self.requestURL!)!)
//        detailView.webView.load(request)
        self.addWebListen()
        self.initKVO()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        detailView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                make.top.bottom.equalTo(self.view)
            }
            make.left.right.equalTo(self.view)
        }
    }
    deinit {
        print("YieldFarmingViewController销毁了")
    }
    override func back() {
        if self.detailView.webView.canGoBack == true {
            self.detailView.webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    /// 子View
    lazy var detailView : YieldFarmingView = {
        let view = YieldFarmingView.init()
        view.webView.navigationDelegate = self
        return view
    }()
    /// 网络请求、数据模型
    private lazy var dataModel: YieldFarmingModel = {
        let model = YieldFarmingModel.init()
        return model
    }()
    var needDismissViewController: Bool?
    var requestURL: String?
    var bridge: WKWebViewJavascriptBridge!
    private var observer: NSKeyValueObservation?
    var publishClosure: (()->Void)?
    var payTokenClosure: (()->Void)?
    func addWebListen() {
        bridge = WKWebViewJavascriptBridge.init(webView: detailView.webView)
        bridge.isLogEnable = true
        bridge.register(handlerName: "callNative") { [weak self] (paramters, callback) in
            if paramters!["method"] as? String == "yield_farming_detail" {
                // 挖矿明细
                let vc = ProfitMainViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            } else if paramters!["method"] as? String == "withdraw_pool_profit" {
                // 资金池挖矿激励提取
                WalletManager.unlockWallet { [weak self] (result) in
                    switch result {
                    case let .success(mnemonic):
                        self?.detailView.toastView.show(tag: 99)
                        self?.dataModel.sendMarketExtractProfit(sendAddress: WalletManager.shared.violasAddress ?? "",
                                                                mnemonic: mnemonic)
                    case let .failure(error):
                        guard error.localizedDescription != "Cancel" else {
                            self?.detailView.toastView.hide(tag: 99)
                            return
                        }
                        self?.view?.makeToast(error.localizedDescription, position: .center)
                    }
                }
            } else if paramters!["method"] as? String == "withdraw_bank_profit" {
                // 数字银行挖矿激励提取
                WalletManager.unlockWallet { [weak self] (result) in
                    switch result {
                    case let .success(mnemonic):
                        self?.detailView.toastView.show(tag: 99)
                        self?.dataModel.sendBankExtractProfit(sendAddress: WalletManager.shared.violasAddress ?? "",
                                                              mnemonic: mnemonic)
                    case let .failure(error):
                        guard error.localizedDescription != "Cancel" else {
                            self?.detailView.toastView.hide(tag: 99)
                            return
                        }
                        self?.view?.makeToast(error.localizedDescription, position: .center)
                    }
                }
            } else if paramters!["method"] as? String == "new_user_check" {
                // 新用户检查
                let vc = EnrollPhoneViewController()
                let navi = BaseNavigationViewController.init(rootViewController: vc)
                self?.present(navi, animated: true, completion: nil)
            } else if paramters!["method"] as? String == "pool_farming" {
                // 资金池挖矿
                self?.navigationController?.dismiss(animated: true, completion: {
                    self?.navigationController?.tabBarController?.selectedIndex = 1
                })
            } else if paramters!["method"] as? String == "bank_loan_farming" {
                // 借款挖矿
                self?.navigationController?.dismiss(animated: true, completion: {
                    self?.navigationController?.tabBarController?.selectedIndex = 2
                })
            } else if paramters!["method"] as? String == "bank_deposit_farming" {
                // 存款挖矿
                self?.navigationController?.dismiss(animated: true, completion: {
                    self?.navigationController?.tabBarController?.selectedIndex = 2
                })
            } else if paramters!["method"] as? String == "mine_invite" {
                // 我的邀请
                let vc = ProfitMainViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            print("testiOSCallback called: \(String(describing: paramters))")
            callback?("Response from testiOSCallback")
        }
        //        bridge.call(handlerName: "callJavaScript", data: ["foo": "before ready"], callback: nil)
        //                        self?.bridge.call(handlerName: "callJavaScript", data: "{\"id\": \"\(String(describing: paramters!["id"]!))\",\"result\": \"failed\"}", callback: nil)
    }
}
extension YieldFarmingViewController :WKNavigationDelegate{
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.view.makeToastActivity(.center)
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.view.hideToastActivity()
        
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        /// 弹出提示框点击确定返回
        self.view.hideToastActivity()
        let alertView = UIAlertController.init(title: localLanguage(keyString: "wallet_service_legal_loaded_error_title"),
                                               message: nil,
                                               preferredStyle: .alert)
        let okAction = UIAlertAction.init(title:localLanguage(keyString: "wallet_service_legal_loaded_error_cancel_button_title"),
                                          style: .default) { okAction in
                                            _=self.navigationController?.popViewController(animated: true)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, cred)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
}
extension YieldFarmingViewController {
    func initKVO() {
        self.observer = dataModel.observe(\.dataDic, options: [.new], changeHandler: { [weak self](model, change) in
            guard let dataDic = change.newValue, dataDic.count != 0 else {
                self?.detailView.hideToastActivity()
                self?.endLoading()
                return
            }
            if let error = dataDic.value(forKey: "error") as? LibraWalletError {
                if error.localizedDescription == LibraWalletError.WalletRequest(reason: .networkInvalid).localizedDescription {
                    // 网络无法访问
                    print(error.localizedDescription)
                    self?.detailView.makeToast(LibraWalletError.WalletRequest(reason: .networkInvalid).localizedDescription, position: .center)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .walletVersionExpired).localizedDescription {
                    // 版本太久
                    print(error.localizedDescription)
                    self?.detailView.makeToast("版本太旧,请及时更新版本", position: .center)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .parseJsonError).localizedDescription {
                    // 解析失败
                    print(error.localizedDescription)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .dataEmpty).localizedDescription {
                    print(error.localizedDescription)
                    // 数据为空
                    self?.detailView.makeToast(LibraWalletError.WalletRequest(reason: .dataEmpty).localizedDescription, position: .center)
                    self?.detailView.hideToastActivity()
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .noMoreData).localizedDescription {
                    print(error.localizedDescription)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .dataCodeInvalid).localizedDescription {
                    print(error.localizedDescription)
                    // 数据状态异常
                    self?.detailView.makeToast(LibraWalletError.WalletRequest(reason: .dataCodeInvalid).localizedDescription, position: .center)
                }
                self?.detailView.toastView.hide(tag: 99)
//                self?.endLoading(animated: true, error: nil, completion: nil)
                return
            }
            let type = dataDic.value(forKey: "type") as! String
            if type == "PublishToken" {
                self?.detailView.toastView.hide(tag: 99)
                if let action = self?.publishClosure {
                    action()
                }
            } else if type == "SendPayTokenTransaction" {
                self?.detailView.toastView.hide(tag: 99)
                if let action = self?.payTokenClosure {
                    action()
                }
            }
            self?.detailView.hideToastActivity()
        })
    }
}