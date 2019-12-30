//
//  BackupMnemonicController.swift
//  LibraWallet
//
//  Created by palliums on 2019/11/4.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit

class BackupMnemonicController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化本地配置
        self.title = localLanguage(keyString: "wallet_backup_mnemonic_show_navigationbar_title")
        // 加载子View
        self.view.addSubview(self.viewModel.detailView)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewModel.detailView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                make.top.bottom.equalTo(self.view)
            }
            make.left.right.bottom.equalTo(self.view)
        }
    }
    deinit {
        print("BackupMnemonicController销毁了")
    }
    typealias nextActionClosure = (ControllerAction, LibraWalletManager) -> Void
    var actionClosure: nextActionClosure?
    lazy var viewModel: BackupMnemonicViewModel = {
        let viewModel = BackupMnemonicViewModel.init()
        viewModel.detailView.delegate = self
        return viewModel
    }()
    var FirstInApp: Bool?
    var JustShow: Bool? {
        didSet {
            self.viewModel.detailView.JustShow = JustShow
        }
    }
    var tempWallet: CreateWalletModel? {
        didSet {
            self.viewModel.dataArray = tempWallet?.mnemonic
        }
    }
}
extension BackupMnemonicController: BackupMnemonicViewDelegate {
    func checkBackupMnemonic() {
        let vc = CheckBackupViewController()
        vc.FirstInApp = self.FirstInApp
        vc.tempWallet = self.tempWallet
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
