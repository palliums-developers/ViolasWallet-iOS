//
//  DepositTableViewCell.swift
//  LibraWallet
//
//  Created by wangyingdong on 2020/8/26.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit

class DepositTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.init(hex: "F7F7F9")
        contentView.addSubview(whiteBackgroundView)
        whiteBackgroundView.addSubview(itemTitleLabel)
        whiteBackgroundView.addSubview(itemTitleDescribeLabel)
        whiteBackgroundView.addSubview(itemContentLabel)
        whiteBackgroundView.addSubview(spaceLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("DepositTableViewCell销毁了")
    }
    //pragma MARK: 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        whiteBackgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView.snp.right).offset(-15)
            make.top.bottom.equalTo(contentView)
        }
        itemTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(whiteBackgroundView).priority(250)
            make.left.equalTo(whiteBackgroundView).offset(13).priority(250)
        }
        itemTitleDescribeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(whiteBackgroundView).offset(10)
            make.left.equalTo(whiteBackgroundView).offset(13)
        }
        itemContentLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(itemTitleLabel)
            make.right.equalTo(whiteBackgroundView.snp.right).offset(-12)
        }
        spaceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(whiteBackgroundView).offset(13)
            make.bottom.equalTo(whiteBackgroundView.snp.bottom)
            make.right.equalTo(whiteBackgroundView.snp.right).offset(-12)
            make.height.equalTo(0.5)
        }
    }
    // MARK: - 懒加载对象
    private lazy var whiteBackgroundView: UIView = {
        let view = UIView.init()
        view.layer.backgroundColor = UIColor.white.cgColor
        return view
    }()
    lazy var itemTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.init(hex: "5C5C5C")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: UIFont.Weight.regular)
        label.text = "---"
        return label
    }()
    lazy var itemTitleDescribeLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.init(hex: "BABABA")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 10), weight: UIFont.Weight.regular)
        label.text = ""
        label.alpha = 0
        return label
    }()
    lazy var itemContentLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor.init(hex: "333333")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: UIFont.Weight.regular)
        label.text = "---"
        return label
    }()
    lazy var spaceLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = DefaultSpaceColor
        return label
    }()
    //MARK: - 设置数据
    var indexPath: IndexPath?
    var hideSpcaeLineState: Bool? {
        didSet {
            if hideSpcaeLineState == true {
                spaceLabel.alpha = 0
            } else {
                spaceLabel.alpha = 1
            }
        }
    }
    var model: DepositLocalDataModel? {
        didSet {
            guard let tempModel = model else {
                return
            }
            itemTitleLabel.text = tempModel.title
            itemContentLabel.text = tempModel.content
            itemContentLabel.textColor = UIColor.init(hex: tempModel.contentColor)
            itemContentLabel.font = tempModel.conentFont
            if tempModel.titleDescribe.isEmpty == false {
                itemTitleDescribeLabel.text = tempModel.titleDescribe
                itemTitleDescribeLabel.alpha = 1
                itemTitleLabel.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(whiteBackgroundView).offset(-10)
                    make.left.equalTo(whiteBackgroundView).offset(13)
                }
            } else {
                itemTitleDescribeLabel.alpha = 0
                itemTitleLabel.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(whiteBackgroundView)
                    make.left.equalTo(whiteBackgroundView).offset(13)
                }
            }
        }
    }
}
