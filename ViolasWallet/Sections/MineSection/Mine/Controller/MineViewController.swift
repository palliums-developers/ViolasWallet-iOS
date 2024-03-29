//
//  MineViewController.swift
//  ViolasWallet
//
//  Created by palliums on 2019/10/23.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit
import Localize_Swift
class MineViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hex: "F7F7F9")
        // 加载子View
        self.view.addSubview(self.detailView)
        // 加载数据
        self.getLocalData()
        // 添加语言变换通知
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.barStyle = .black
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.barStyle = .default
//    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        detailView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        print("MineViewController销毁了")
    }
    @objc func setText() {
        self.getLocalData()
    }
    func getLocalData() {
        self.tableViewManager.dataModel = self.dataModel.getLocalData()
        self.detailView.tableView.reloadData()
    }
    /// 网络请求、数据模型
    lazy var dataModel: MineModel = {
        let model = MineModel.init()
        return model
    }()
    /// tableView管理类
    lazy var tableViewManager: MineTableViewManager = {
        let manager = MineTableViewManager.init()
        manager.delegate = self
        return manager
    }()
    /// 子View
    lazy var detailView : MineView = {
        let view = MineView.init()
        view.tableView.delegate = self.tableViewManager
        view.tableView.dataSource = self.tableViewManager
        return view
    }()
}
extension MineViewController: MineTableViewManagerDelegate {
    func tableViewDidSelectRowAtIndexPath(indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                guard getIdentityWalletState() == true else {
                    self.tabBarController?.selectedIndex = 0
                    return
                }
                let vc = WalletConfigViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.canDelete = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = AddressManagerViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                guard getIdentityWalletState() == true else {
                    self.tabBarController?.selectedIndex = 0
                    return
                }
                let vc = YieldFarmingViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                guard getIdentityWalletState() == true else {
                    self.tabBarController?.selectedIndex = 0
                    return
                }
                let vc = InvitationRewardViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if indexPath.section == 4 {
            if indexPath.row == 0 {
                let vc = SettingViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if indexPath.section == 5 {
            if indexPath.row == 0 {
//                let vc = ActiveAccountViewController()
//                //                vc.authKey = LibraWalletManager.shared.walletAuthenticationKey
//                vc.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
//
