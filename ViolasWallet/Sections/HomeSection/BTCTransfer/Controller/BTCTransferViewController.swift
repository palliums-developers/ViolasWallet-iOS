//
//  BTCTransferViewController.swift
//  ViolasWallet
//
//  Created by palliums on 2019/11/14.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit

class BTCTransferViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = (self.wallet?.tokenName ?? "") + " " + localLanguage(keyString: "wallet_transfer_navigation_title")

        self.view.addSubview(detailView)
        self.detailView.wallet = self.wallet

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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }
    //子View
    private lazy var detailView : BTCTransferView = {
        let view = BTCTransferView.init()
        view.delegate = self
        return view
    }()
    lazy var dataModel: BTCTransferModel = {
        let model = BTCTransferModel.init()
        return model
    }()
    typealias successClosure = () -> Void
    var actionClosure: successClosure?
    var myContext = 0
    var wallet: Token?
    var address: String? {
        didSet {
           self.detailView.addressTextField.text = address
        }
    }
    var amount: UInt64? {
        didSet {
            guard let tempAmount = amount else {
                return
            }
            let amountContent = getDecimalNumberAmount(amount: NSDecimalNumber.init(value: tempAmount),
                                                       scale: 8,
                                                       unit: 100000000)
            self.detailView.amountTextField.text = "\(amountContent)"
        }
    }
}
extension BTCTransferViewController {
    //MARK: - KVO
    func initKVO() {
        dataModel.addObserver(self, forKeyPath: "dataDic", options: NSKeyValueObservingOptions.new, context: &myContext)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)  {
        
        guard context == &myContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        guard (change?[NSKeyValueChangeKey.newKey]) != nil else {
            return
        }
        guard let jsonData = (object! as AnyObject).value(forKey: "dataDic") as? NSDictionary else {
            return
        }
        if let error = jsonData.value(forKey: "error") as? LibraWalletError {
            if error.localizedDescription == LibraWalletError.WalletRequest(reason: .networkInvalid).localizedDescription {
                // 网络无法访问
                print(error.localizedDescription)
            } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .walletTokenExpired).localizedDescription {
                // 钱包不存在
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
                // 数据状态异常
            }
            self.detailView.toastView?.hide(tag: 99)
            self.view.makeToast(error.localizedDescription, position: .center)
            return
        }
        let type = jsonData.value(forKey: "type") as! String
        
        if type == "SendBTCTransaction" {
            print("SendBTCsuccess")
            self.detailView.toastView?.hide(tag: 99)
            self.view.makeToast(localLanguage(keyString: "wallet_transfer_success_alert"), position: .center)
        }
        self.view.hideToastActivity()
    }
}
extension BTCTransferViewController: BTCTransferViewDelegate {
    
    
    func scanAddressQRcode() {
        let vc = ScanViewController()
        vc.actionClosure = { address in
//            do {
//                let tempAddressModel = try handleScanContent(content: address)
//                self.detailView.addressTextField.text = tempAddressModel.address
//            } catch {
//                self.detailView.makeToast(error.localizedDescription, position: .center)
//            }
            do {
                let result = try ScanHandleManager.scanResultHandle(content: address, contracts: [self.wallet!])
                if result.type == .transfer {
                    switch result.addressType {
                    case .BTC:
                        self.detailView.addressTextField.text = result.address
                        self.amount = result.amount
                    default:
                        self.detailView.addressTextField.text?.removeAll()
                        self.detailView.amountTextField.text?.removeAll()
                        self.view.makeToast(LibraWalletError.WalletScan(reason: LibraWalletError.ScanError.btcAddressInvalid).localizedDescription,
                                            position: .center)
                    }
                } else {
                    self.view.makeToast(LibraWalletError.WalletScan(reason: LibraWalletError.ScanError.btcAddressInvalid).localizedDescription,
                                        position: .center)
                }
            } catch {
                self.view.makeToast(error.localizedDescription, position: .center)
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func chooseAddress() {
        let vc = AddressManagerViewController()
        vc.actionClosure = { address in
            self.detailView.addressTextField.text = address
        }
        vc.addressType = "2"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func confirmWithdraw() {
//        self.view.makeToastActivity(.center)
//        self.dataModel.transfer(address: self.detailView.addressTextField.text!,
//                                amount: Double(self.detailView.amountTextField.text!)!,
//                                rootAddress: (self.wallet?.walletRootAddress)!)
//        self.dataModel.getViolasSequenceNumber(address: (self.wallet?.walletAddress)!)

//    }
    func confirmTransfer(amount: Double, address: String, fee: Double) {
        WalletManager.unlockWallet { [weak self] (result) in
            switch result {
            case let .success(mnemonic):
                self?.detailView.toastView?.show(tag: 99)
                let walletttt = try! BTCManager().getWallet(mnemonic: mnemonic)
                self?.dataModel.makeTransaction(wallet: walletttt,
                                                amount: amount,
                                                fee: fee,
                                                toAddress: address)
            case let .failure(error):
                guard error.localizedDescription != "Cancel" else {
                    self?.detailView.toastView?.hide(tag: 99)
                    return
                }
                self?.detailView.makeToast(error.localizedDescription, position: .center)
            }
        }
    }
}
