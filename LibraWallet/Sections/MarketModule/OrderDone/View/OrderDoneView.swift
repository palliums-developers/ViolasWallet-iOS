//
//  OrderDoneView.swift
//  LibraWallet
//
//  Created by palliums on 2019/12/17.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit

class OrderDoneView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("OrderDoneView销毁了")
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
        tableView.register(OrderCenterTableViewCell.classForCoder(), forCellReuseIdentifier: "OrderDoneCell")
        return tableView
    }()
}
