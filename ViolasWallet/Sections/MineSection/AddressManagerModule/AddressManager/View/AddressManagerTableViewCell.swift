//
//  AddressManagerTableViewCell.swift
//  HKWallet
//
//  Created by palliums on 2019/7/25.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit

class AddressManagerTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.init(hex: "F7F7F9")
        contentView.addSubview(addressBackgroundView)
        contentView.addSubview(nameLabel)
        addressBackgroundView.addSubview(addressLabel)
        addressBackgroundView.addSubview(addressTypeLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("AddressManagerTableViewCell销毁了")
    }
    //MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(addressBackgroundView.snp.top).offset(-5)
            make.left.equalTo(contentView).offset(19)
            make.right.equalTo(addressTypeLabel.snp.left).offset(-5)
        }
        addressBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(38)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-4)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(addressBackgroundView)
            make.left.equalTo(addressBackgroundView).offset(13)
            make.right.equalTo(addressBackgroundView.snp.right).offset(-5)

        }
        addressTypeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.size.equalTo(CGSize.init(width: 55, height: 23))
        }
//        //防止用户名字挤压
//        //宽度不够时，可以被压缩
//        nameLabel.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: NSLayoutConstraint.Axis.horizontal)
//        //抱紧内容
//        nameLabel.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
//        //不可以被压缩，尽量显示完整
//        addressTypeLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
    }
    //MARK: - 懒加载对象
    private lazy var addressBackgroundView: UIView = {
        let view = UIView.init()
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.cornerRadius = 16
        return view
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.init(hex: "3C3848")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 16), weight: UIFont.Weight.regular)
        label.text = "---"
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.init(hex: "3C3848")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: UIFont.Weight.regular)
        label.text = "---"
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    lazy var addressTypeLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.init(hex: "AEAEAE")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 12), weight: UIFont.Weight.regular)
        label.text = "---"
        label.layer.backgroundColor = UIColor.init(hex: "F5F4F4").cgColor
        label.layer.cornerRadius = 7
        return label
    }()
    //MARK: - 设置数据
    var dataModel: AddressModel? {
        didSet {
            addressLabel.text = dataModel?.address
            nameLabel.text = dataModel?.addressName
            if dataModel?.addressType == "0" {
                addressTypeLabel.text = "Libra"
            } else if dataModel?.addressType == "1" {
                addressTypeLabel.text = "Violas"
            }  else if dataModel?.addressType == "1" {
                addressTypeLabel.text = "BTC"
            }
        }
    }
}
