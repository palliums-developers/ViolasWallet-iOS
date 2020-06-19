//
//  ScanSignTransactionViewController.swift
//  LibraWallet
//
//  Created by wangyingdong on 2020/5/21.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit
import Toast_Swift
class ScanSignTransactionViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initKVO()
        self.view.addSubview(detailView)
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
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if needReject == true {
            if let rejectC = self.reject {
                rejectC()
            }
        }
    }
    deinit {
        print("ScanSignTransactionViewController销毁了")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }
    private lazy var detailView : ScanSignTransactionView = {
        let view = ScanSignTransactionView.init()
        view.delegate = self
        return view
    }()
    lazy var dataModel: ScanSignTransactionModel = {
        let model = ScanSignTransactionModel.init()
        return model
    }()
    var model: WCSignTransactionModel?
    /// 数据监听KVO
    var observer: NSKeyValueObservation?
    var reject: (() -> Void)?
    var confirm: ((String) -> Void)?
    var needReject: Bool? = true
}
extension ScanSignTransactionViewController: ScanSignTransactionViewDelegate {
    func cancelLogin() {
        self.dismiss(animated: true, completion: {
            if let rejectC = self.reject {
                rejectC()
            }
        })
        self.needReject = false
    }
    func confirmLogin(password: String) {
        NSLog("Password:\(password)")
        if let raw = self.model {
//            if LibraWalletManager.shared.walletBiometricLock == true {
                KeychainManager().getPasswordWithBiometric(walletAddress: "Violas_" + (raw.address ?? "")) { [weak self](result, error) in
                    if result.isEmpty == false {
                        do {
                            let mnemonic = try WalletManager.getMnemonicFromKeychain(password: result)
                            self?.detailView.toastView?.show()
                            self?.dataModel.signMessage(message: raw.message ?? "", mnemonic: mnemonic)
                        } catch {
                            self?.detailView.makeToast(error.localizedDescription, position: .center)
                        }
                        
                    } else {
                        self?.detailView.makeToast(error, position: .center)
                    }
                }
//            } else {
//                let alert = passowordAlert(rootAddress: "Violas_" + (raw.address ?? ""), mnemonic: { [weak self] (mnemonic) in
//                    self?.detailView.toastView?.show()
//                    self?.dataModel.signMessage(message: raw.message ?? "", mnemonic: mnemonic)
//                }) { [weak self] (errorContent) in
//                    guard errorContent != "Cancel" else {
//                        self?.detailView.toastView?.hide()
//                        return
//                    }
//                    self?.view.makeToast(errorContent, position: .center)
//                }
//                self.present(alert, animated: true, completion: nil)
//
//            }
        } else {
            #warning("报错待处理")
        }

    }
}
extension ScanSignTransactionViewController {
    func initKVO() {
        self.observer = dataModel.observe(\.dataDic, options: [.new], changeHandler: { [weak self](model, change) in
            guard let dataDic = change.newValue, dataDic.count != 0 else {
                self?.detailView.hideToastActivity()
//                self?.endLoading()
                return
            }
            let type = dataDic.value(forKey: "type") as! String
            if let error = dataDic.value(forKey: "error") as? LibraWalletError {
                if error.localizedDescription == LibraWalletError.WalletRequest(reason: .networkInvalid).localizedDescription {
                    // 网络无法访问
                    print(error.localizedDescription)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .walletVersionExpired).localizedDescription {
                    // 版本太久
                    print(error.localizedDescription)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .parseJsonError).localizedDescription {
                    // 解析失败
                    print(error.localizedDescription)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .dataEmpty).localizedDescription {
                    print(error.localizedDescription)
                    // 数据为空
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .dataCodeInvalid).localizedDescription {
                    print(error.localizedDescription)
                    // 数据返回状态异常
                }
                self?.detailView.toastView?.hide()
                self?.detailView.hideToastActivity()
                self?.detailView.makeToast(error.localizedDescription, position: .center)
                return
            }
            self?.detailView.toastView?.hide()
            if type == "SignMessage" {
                if let tempData = dataDic.value(forKey: "data") as? String {
                    self?.view.makeToast(localLanguage(keyString: "wallet_scan_login_alert_success_title"), duration: toastDuration, position: .center, title: nil, image: nil, style: ToastManager.shared.style, completion: { (bool) in
                        self?.needReject = false
                        if let confirmAction = self?.confirm {
                            confirmAction(tempData)
                        }
                        self?.dismiss(animated: true, completion: nil)
                    })
                }
            }
        })
    }
}
