//
//  MappingTransactionsView.swift
//  ViolasWallet
//
//  Created by wangyingdong on 2020/2/18.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit

class MappingTransactionsView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("MappingTransactionsView销毁了")
    }
    //MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.right.bottom.equalTo(self)
        }
    }
    //MARK: - 懒加载对象
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.backgroundColor = UIColor.white
        tableView.register(MappingTransactionsTableViewCell.classForCoder(), forCellReuseIdentifier: "CellNormal")
        return tableView
    }()

}
