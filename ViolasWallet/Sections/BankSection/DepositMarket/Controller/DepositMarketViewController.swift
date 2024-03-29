//
//  DepositMarketViewController.swift
//  ViolasWallet
//
//  Created by wangyingdong on 2020/8/19.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit
import MJRefresh
import JXSegmentedView

protocol DepositMarketViewControllerDelegate: NSObjectProtocol {
    func refreshAccount()
}
class DepositMarketViewController: BaseViewController {
    weak var delegate: DepositMarketViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.view.addSubview(self.detailView)
        //设置空数据页面
        self.setEmptyView()
        //设置默认页面（无数据、无网络）
        self.setPlaceholderView()
    }
    //    override func viewWillLayoutSubviews() {
    //        super.viewWillLayoutSubviews()
    //        detailView.snp.makeConstraints { (make) in
    //            if #available(iOS 11.0, *) {
    //                make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
    //            } else {
    //                make.top.bottom.equalTo(self.view)
    //            }
    //            make.left.right.equalTo(self.view)
    //        }
    //    }
    deinit {
        print("DepositMarketViewController销毁了")
    }
    // 默认页面
    func setPlaceholderView() {
        if let empty = emptyView as? EmptyDataPlaceholderView {
            empty.emptyImageName = "transaction_list_empty_default"
            empty.tipString = localLanguage(keyString: "wallet_transactions_empty_default_title")
        }
    }
    // 网络请求
    func requestData() {
        if (lastState == .Loading) {return}
        startLoading ()
        transactionRequest(refresh: true)
    }
    override func hasContent() -> Bool {
        if let models = self.tableViewManager.dataModels, models.isEmpty == false {
            return true
        } else {
            return false
        }
    }
    /// 网络请求、数据模型
    lazy var dataModel: DepositMarketModel = {
        let model = DepositMarketModel.init()
        return model
    }()
    /// tableView管理类
    lazy var tableViewManager: DepositMarketTableViewManager = {
        let manager = DepositMarketTableViewManager.init()
        return manager
    }()
    /// 子View
    lazy var detailView : DepositMarketView = {
        let view = DepositMarketView.init()
        view.tableView.delegate = self.tableViewManager
        view.tableView.dataSource = self.tableViewManager
        view.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction:  #selector(refreshData))
        //        view.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction:  #selector(getMoreData))
        return view
    }()
    /// 页数
    var dataOffset: Int = 0
    /// 防止多次点击
    var firstIn: Bool = true
}

// MARK: - 网络请求
extension DepositMarketViewController {
    @objc func refreshData() {
        dataOffset = 0
        detailView.tableView.mj_footer?.resetNoMoreData()
        transactionRequest(refresh: true)
    }
    @objc func getMoreData() {
        dataOffset += 10
        transactionRequest(refresh: false)
    }
    func transactionRequest(refresh: Bool) {
        if refresh == true {
            self.delegate?.refreshAccount()
        }
        self.dataModel.getDepositMarket(refresh: refresh) { [weak self] (result) in
            switch result {
            case let .success(models):
                if refresh == true {
                    guard models.isEmpty == false else {
                        self?.detailView.hideToastActivity()
                        self?.tableViewManager.dataModels?.removeAll()
                        self?.detailView.tableView.reloadData()
                        self?.detailView.tableView.mj_header?.endRefreshing()
                        self?.endLoading()
                        return
                    }
                    self?.detailView.hideToastActivity()
                    // 下拉刷新
                    self?.tableViewManager.dataModels = models
                    self?.detailView.tableView.reloadData()
                    self?.detailView.tableView.mj_header?.endRefreshing()
                } else {
                    // 上拉刷新
                    guard models.isEmpty == false else {
                        self?.detailView.tableView.mj_footer?.endRefreshingWithNoMoreData()
                        return
                    }
                    guard let oldData = self?.tableViewManager.dataModels, oldData.isEmpty == false else {
                        self?.tableViewManager.dataModels = models
                        self?.detailView.tableView.reloadData()
                        return
                    }
                    var insertIndexPath = [IndexPath]()
                    for index in 0..<models.count {
                        let indexPath = IndexPath.init(row: oldData.count + index, section: 0)
                        insertIndexPath.append(indexPath)
                    }
                    self?.tableViewManager.dataModels = oldData + models
                    self?.detailView.tableView.beginUpdates()
                    self?.detailView.tableView.insertRows(at: insertIndexPath, with: UITableView.RowAnimation.bottom)
                    self?.detailView.tableView.endUpdates()
                    self?.detailView.tableView.mj_footer?.endRefreshing()
                }
            case let .failure(error):
                self?.detailView.hideToastActivity()
                if refresh == true {
                    if self?.detailView.tableView.mj_header?.isRefreshing == true {
                        self?.detailView.tableView.mj_header?.endRefreshing()
                    }
                } else {
                    if self?.detailView.tableView.mj_footer?.isRefreshing == true {
                        self?.detailView.tableView.mj_footer?.endRefreshing()
                    }
                }
                self?.handleError(requestType: "", error: error)
            }
            self?.endLoading()
        }
    }
}
// MARK: - 网络请求数据处理
extension DepositMarketViewController {
    func handleError(requestType: String, error: LibraWalletError) {
        switch error {
        case .WalletRequest(reason: .networkInvalid):
            // 网络无法访问
            print(error.localizedDescription)
        case .WalletRequest(reason: .walletVersionExpired):
            // 版本太久
            print(error.localizedDescription)
        case .WalletRequest(reason: .parseJsonError):
            // 解析失败
            print(error.localizedDescription)
        case .WalletRequest(reason: .dataCodeInvalid):
            // 数据状态异常
            print(error.localizedDescription)
        default:
            // 其他错误
            print(error.localizedDescription)
        }
        self.view?.makeToast(error.localizedDescription, position: .center)
    }
}
extension DepositMarketViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.detailView
    }
    /// 可选实现，列表显示的时候调用
    func listDidAppear() {
        //防止重复加载数据
        guard firstIn == true else {
            return
        }
        if (lastState == .Loading) {return}
        startLoading ()
        self.detailView.tableView.mj_header?.beginRefreshing()
        firstIn = false
    }
    /// 可选实现，列表消失的时候调用
    func listDidDisappear() {
        
    }
}
