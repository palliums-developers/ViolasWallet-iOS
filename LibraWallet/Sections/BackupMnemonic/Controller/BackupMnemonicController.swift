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
        self.setBaseControlllerConfig()
        
        // 加载数据
        self.mnemonicArray = ["legal","winner","thank","year","wave","sausage","worth","useful","legal","winner","thank","year","wave","sausage","worth","useful","legal","will"]
        // 加载子View
        self.view.addSubview(self.viewModel.detailView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barStyle = .black
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewModel.detailView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                make.top.bottom.equalTo(self.view)
            }
            make.left.right.equalTo(self.view)
        }
    }
    deinit {
        print("WalletListController销毁了")
    }
    typealias nextActionClosure = (ControllerAction, LibraWalletManager) -> Void
    var actionClosure: nextActionClosure?
    lazy var viewModel: BackupMnemonicViewModel = {
        let viewModel = BackupMnemonicViewModel.init()
        viewModel.detailView.delegate = self
        return viewModel
    }()
    var mnemonicArray: [String]? {
        didSet {
            self.viewModel.dataArray = mnemonicArray
        }
    }
    
}
extension BackupMnemonicController: BackupMnemonicViewDelegate {
    func checkBackupMnemonic() {
        
    }
}
