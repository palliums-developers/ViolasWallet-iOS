//
//  ExchangeTransactionsViewController.swift
//  ViolasWallet
//
//  Created by wangyingdong on 2020/7/14.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit
import MJRefresh
class ExchangeTransactionsViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = localLanguage(keyString: "wallet_market_exchange_transactions_navigationbar_title")
        // 加载子View
        self.view.addSubview(detailView)
        // 初始化KVO
        self.initKVO()
//        // 请求数据
//        self.detailView.tableView.mj_header?.beginRefreshing()
        //设置空数据页面
        self.setEmptyView()
        //设置默认页面（无数据、无网络）
        self.setPlaceholderView()

        self.requestData()
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
        print("ExchangeTransactionsViewController销毁了")
    }
    func setPlaceholderView() {
        if let empty = emptyView as? EmptyDataPlaceholderView {
            empty.emptyImageName = "data_empty"
            empty.tipString = localLanguage(keyString: "wallet_bank_loan_orders_empty_title")
        }
    }
    func requestData() {
        if (lastState == .Loading) {return}
        startLoading ()
        self.detailView.makeToastActivity(.center)
        
        refreshData()
    }
    override func hasContent() -> Bool {
        if let models = self.tableViewManager.dataModels, models.isEmpty == false {
            return true
        } else {
            return false
        }
    }
    /// 网络请求、数据模型
    lazy var dataModel: ExchangeTransactionsModel = {
        let model = ExchangeTransactionsModel.init()
        return model
    }()
    /// tableView管理类
    lazy var tableViewManager: ExchangeTransactionsTableViewManager = {
        let manager = ExchangeTransactionsTableViewManager.init()
        manager.delegate = self
        return manager
    }()
    /// 子View
    lazy var detailView : ExchangeTransactionsView = {
        let view = ExchangeTransactionsView.init()
        view.tableView.delegate = self.tableViewManager
        view.tableView.dataSource = self.tableViewManager
        view.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction:  #selector(refreshData))
        view.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction:  #selector(getMoreData))
        return view
    }()
    /// 数据监听KVO
    var observer: NSKeyValueObservation?
    var dataOffset: Int = 0
    @objc func refreshData() {
        dataOffset = 0
        detailView.tableView.mj_footer?.resetNoMoreData()
//        self.dataModel.getExchangeTransactions(address: WalletManager.shared.violasAddress ?? "",
//                                               page: dataOffset,
//                                               pageSize: 10,
//                                               requestStatus: 0)
        self.dataModel.getAllExchangeTrans(page: dataOffset,
                                           pageSize: 10,
                                           requestStatus: 0)
    }
    @objc func getMoreData() {
        dataOffset += 10
//        self.dataModel.getExchangeTransactions(address: WalletManager.shared.violasAddress ?? "",
//                                               page: dataOffset,
//                                               pageSize: 10,
//                                               requestStatus: 1)
        self.dataModel.getAllExchangeTrans(page: dataOffset,
                                           pageSize: 10,
                                           requestStatus: 1)
    }
}
extension ExchangeTransactionsViewController: ExchangeTransactionsTableViewManagerDelegate {
    func tableViewDidSelectRowAtIndexPath(indexPath: IndexPath, model: ExchangeTransactionsDataModel) {
        let vc = ExchangeTransactionDetailViewController()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension ExchangeTransactionsViewController {
    func initKVO() {
        self.observer = dataModel.observe(\.dataDic, options: [.new], changeHandler: { [weak self](model, change) in
            guard let dataDic = change.newValue, dataDic.count != 0 else {
                self?.detailView.hideToastActivity()
                return
            }
            if let error = dataDic.value(forKey: "error") as? LibraWalletError {
                self?.detailView.hideToastActivity()
                if self?.detailView.tableView.mj_footer?.isRefreshing == true {
                    self?.detailView.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
                if self?.detailView.tableView.mj_header?.isRefreshing == true {
                    self?.detailView.tableView.mj_header?.endRefreshing()
                }
                switch error {
                case .WalletRequest(reason: .networkInvalid):
                    self?.detailView.makeToast(error.localizedDescription,
                                               position: .center)
                case .WalletRequest(reason: .walletVersionExpired):
                    self?.detailView.makeToast(error.localizedDescription,
                                               position: .center)
                case .WalletRequest(reason: .parseJsonError):
                    self?.detailView.makeToast(error.localizedDescription,
                                               position: .center)
                case .WalletRequest(reason: .dataCodeInvalid):
                    self?.detailView.makeToast(error.localizedDescription,
                                               position: .center)
                case .WalletRequest(reason: .dataEmpty):
                    self?.tableViewManager.dataModels?.removeAll()
                    self?.detailView.tableView.reloadData()
                    self?.detailView.makeToast(error.localizedDescription,
                                               position: .center)
                case .WalletRequest(reason: .noMoreData):
                    self?.detailView.tableView.mj_footer?.endRefreshingWithNoMoreData()
                default:
                    print(error)
                }
                self?.endLoading()
                return
            }
            let type = dataDic.value(forKey: "type") as! String
            if type == "ExchangeTransactionsOrigin" {
                guard let tempData = dataDic.value(forKey: "data") as? [ExchangeTransactionsDataModel] else {
                    return
                }
                self?.tableViewManager.dataModels = tempData
                self?.detailView.tableView.reloadData()
            } else if type == "ExchangeTransactionsMore" {
                guard let tempData = dataDic.value(forKey: "data") as? [ExchangeTransactionsDataModel] else {
                    return
                }
                if let oldData = self?.tableViewManager.dataModels, oldData.isEmpty == false {
                    var insertIndexPath = [IndexPath]()
                    for index in 0..<tempData.count {
                        let indexPath = IndexPath.init(row: oldData.count + index, section: 0)
                        insertIndexPath.append(indexPath)
                    }
                    self?.tableViewManager.dataModels = oldData + tempData
                    self?.detailView.tableView.beginUpdates()
                    self?.detailView.tableView.insertRows(at: insertIndexPath, with: UITableView.RowAnimation.bottom)
                    self?.detailView.tableView.endUpdates()
                } else {
                    self?.tableViewManager.dataModels = tempData
                    self?.detailView.tableView.reloadData()
                }
                self?.detailView.tableView.mj_footer?.endRefreshing()
            } else if type == "GetMarketSupportTokens" {
                guard let tempData = dataDic.value(forKey: "data") as? [MarketSupportTokensDataModel] else {
                    return
                }
                let alert = MappingTokenListAlert.init(data: tempData) { (model) in
                    print(model)
                }
                alert.show(tag: 99)
                alert.showAnimation()
            }
            self?.detailView.hideToastActivity()
            self?.detailView.tableView.mj_header?.endRefreshing()
            self?.endLoading()
        })
    }
}

