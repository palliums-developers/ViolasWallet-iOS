//
//  ExchangeViewController.swift
//  LibraWallet
//
//  Created by wangyingdong on 2020/7/9.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit
class ExchangeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // 加载子View
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }
    deinit {
        print("ExchangeViewController销毁了")
    }
    /// 网络请求、数据模型
    lazy var dataModel: ExchangeModel = {
        let model = ExchangeModel.init()
        return model
    }()
    /// 子View
    lazy var detailView : ExchangeView = {
        let view = ExchangeView.init()
        view.headerView.delegate = self
        return view
    }()
    /// 数据监听KVO
    var observer: NSKeyValueObservation?
}
extension ExchangeViewController: ExchangeViewHeaderViewDelegate {
    func exchangeConfirm() {
        print("Exchange")
    }
    func selectInputToken() {
        self.detailView.makeToastActivity(.center)
        self.dataModel.getMarketSupportTokens()
    }
    func selectOutoutToken() {
        print("selectOutoutToken")
    }
    func swapInputOutputToken() {
        print("Swap")
    }
    
    
}
extension ExchangeViewController {
    func initKVO() {
        self.observer = dataModel.observe(\.dataDic, options: [.new], changeHandler: { [weak self](model, change) in
            guard let dataDic = change.newValue, dataDic.count != 0 else {
                self?.detailView.hideToastActivity()
                return
            }
            #warning("已修改完成，可拷贝执行")
            if let error = dataDic.value(forKey: "error") as? LibraWalletError {
                // 隐藏请求指示
                self?.detailView.hideToastActivity()
                if error.localizedDescription == LibraWalletError.WalletRequest(reason: .networkInvalid).localizedDescription {
                    // 网络无法访问
                    print(error.localizedDescription)
                    self?.detailView.makeToast(error.localizedDescription,
                                               position: .center)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .walletVersionExpired).localizedDescription {
                    // 版本太久
                    print(error.localizedDescription)
                    self?.detailView.makeToast(error.localizedDescription,
                                               position: .center)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .parseJsonError).localizedDescription {
                    // 解析失败
                    print(error.localizedDescription)
                    self?.detailView.makeToast(error.localizedDescription,
                                               position: .center)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .dataCodeInvalid).localizedDescription {
                    print(error.localizedDescription)
                    // 数据状态异常
                    self?.detailView.makeToast(error.localizedDescription,
                                               position: .center)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .dataEmpty).localizedDescription {
                    print(error.localizedDescription)
                    // 下拉刷新请求数据为空
                    self?.detailView.makeToast(error.localizedDescription,
                                               position: .center)
                } else if error.localizedDescription == LibraWalletError.WalletRequest(reason: .noMoreData).localizedDescription {
                    // 上拉请求更多数据为空
                    print(error.localizedDescription)
                }
                return
            }
            let type = dataDic.value(forKey: "type") as! String
//            if type == "ExchangeTransactionsOrigin" {
//                guard let tempData = dataDic.value(forKey: "data") as? [ExchangeTransactionsDataModel] else {
//                    return
//                }
//                self?.tableViewManager.dataModels = tempData
//                self?.detailView.tableView.reloadData()
//            } else if type == "ExchangeTransactionsMore" {
//                guard let tempData = dataDic.value(forKey: "data") as? [ExchangeTransactionsDataModel] else {
//                    return
//                }
//                if let oldData = self?.tableViewManager.dataModels, oldData.isEmpty == false {
//                    let tempArray = NSMutableArray.init(array: oldData)
//                    var insertIndexPath = [IndexPath]()
//                    for index in 0..<tempData.count {
//                        let indexPath = IndexPath.init(row: oldData.count + index, section: 0)
//                        insertIndexPath.append(indexPath)
//                    }
//                    tempArray.addObjects(from: tempData)
//                    self?.tableViewManager.dataModels = tempArray as? [ExchangeTransactionsDataModel]
//                    self?.detailView.tableView.beginUpdates()
//                    self?.detailView.tableView.insertRows(at: insertIndexPath, with: UITableView.RowAnimation.bottom)
//                    self?.detailView.tableView.endUpdates()
//                } else {
//                    self?.tableViewManager.dataModels = tempData
//                    self?.detailView.tableView.reloadData()
//                }
//                self?.detailView.tableView.mj_footer?.endRefreshing()
//            } else if type == "GetMarketSupportTokens" {
//                guard let tempData = dataDic.value(forKey: "data") as? [MarketSupportTokensDataModel] else {
//                    return
//                }
//                let alert = MappingTokenListAlert.init(data: tempData) { (model) in
//                    print(model)
//                }
//                alert.show(tag: 99)
//                alert.showAnimation()
//            }
            self?.detailView.hideToastActivity()
        })
    }
}
