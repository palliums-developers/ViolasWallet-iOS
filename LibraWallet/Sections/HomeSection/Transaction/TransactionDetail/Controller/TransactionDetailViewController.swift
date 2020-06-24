//
//  TransactionDetailViewController.swift
//  LibraWallet
//
//  Created by wangyingdong on 2020/6/5.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit

class TransactionDetailViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // 加载子View
        self.view.addSubview(self.detailView)
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationController?.navigationBar.barStyle = .default
     }
     override func viewWillLayoutSubviews() {
         super.viewWillLayoutSubviews()
         self.detailView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
         }
     }
     deinit {
         print("TransactionDetailViewController销毁了")
     }
    /// 网络请求、数据模型
    lazy var dataModel: TransactionDetailModel = {
        let model = TransactionDetailModel.init()
        return model
    }()
    /// tableView管理类
    lazy var tableViewManager: TransactionDetailTableViewManager = {
        let manager = TransactionDetailTableViewManager.init()
//        manager.delegate = self
        return manager
    }()
    /// 子View
    lazy var detailView : TransactionDetailView = {
        let view = TransactionDetailView.init()
        view.tableView.delegate = self.tableViewManager
        view.tableView.dataSource = self.tableViewManager
        return view
    }()
    var violasTransaction: ViolasDataModel? {
        didSet {
            guard let model = violasTransaction else {
                return
            }
            self.detailView.violasTransaction = model
            self.tableViewManager.models = self.dataModel.getViolasTransactionsData(transaction: model)
        }
    }
    var libraTransaction: LibraDataModel? {
        didSet {
            guard let model = libraTransaction else {
                return
            }
            self.detailView.libraTransaction = model
            self.tableViewManager.models = self.dataModel.getLibraTransactionsData(transaction: model)
        }
    }
    var btcTransaction: TrezorBTCTransactionDataModel? {
        didSet {
            guard let model = btcTransaction else {
                return
            }
            self.detailView.btcTransaction = model
            self.tableViewManager.models = self.dataModel.getBTCTransactionsData(transaction: model, requestAddress: tokenAddress ?? "")
        }
    }
    var tokenAddress: String?
}
