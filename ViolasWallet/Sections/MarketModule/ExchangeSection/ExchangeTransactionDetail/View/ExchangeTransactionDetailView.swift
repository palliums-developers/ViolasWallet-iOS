//
//  ExchangeTransactionDetailView.swift
//  ViolasWallet
//
//  Created by wangyingdong on 2020/7/6.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit

class ExchangeTransactionDetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("ExchangeTransactionDetailView销毁了")
    }
    //MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.right.bottom.equalTo(self)
        }
    }
    //MARK: - 懒加载对象
    lazy var tableView: UITableView = {
        let tableView = UITableView.init()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.backgroundColor = UIColor.white
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        tableView.register(ExchangeTransactionDetailTableViewCell.classForCoder(), forCellReuseIdentifier: "NormalCell")
        tableView.register(ExchangeTransactionDetailHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "Header")
        tableView.register(ExchangeTransactionDetailFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: "Footer")

        return tableView
    }()
    var toastView: ToastView? {
        let toast = ToastView.init()
        return toast
    }
}
