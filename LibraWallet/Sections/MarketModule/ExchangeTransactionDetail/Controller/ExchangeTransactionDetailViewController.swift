//
//  ExchangeTransactionDetailViewController.swift
//  LibraWallet
//
//  Created by wangyingdong on 2020/7/6.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit

class ExchangeTransactionDetailViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
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
    deinit {
        print("ExchangeTransactionDetailViewController销毁了")
    }
    //网络请求、数据模型
    lazy var dataModel: ExchangeTransactionDetailModel = {
        let model = ExchangeTransactionDetailModel.init()
        return model
    }()
    //tableView管理类
    lazy var tableViewManager: ExchangeTransactionDetailTableViewMananger = {
        let manager = ExchangeTransactionDetailTableViewMananger.init()
//        manager.delegate = self
        return manager
    }()
    //子View
    lazy var detailView : ExchangeTransactionDetailView = {
        let view = ExchangeTransactionDetailView.init()
        view.tableView.delegate = self.tableViewManager
        view.tableView.dataSource = self.tableViewManager
        return view
    }()
    var firstIn: Bool = true
    var wallet: Token?
    var cancelIndexPath: IndexPath?
}