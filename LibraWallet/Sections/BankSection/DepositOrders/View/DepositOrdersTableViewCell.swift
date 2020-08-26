//
//  DepositOrdersTableViewCell.swift
//  LibraWallet
//
//  Created by wangyingdong on 2020/8/20.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit

class DepositOrdersTableViewCell: UITableViewCell {
    //    weak var delegate: AddAssetViewTableViewCellDelegate?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        contentView.addSubview(iconImageView)
        contentView.backgroundColor = UIColor.init(hex: "F7F7F9")
        contentView.addSubview(whiteBackgroundView)
        whiteBackgroundView.addSubview(tokenIconImageView)
        whiteBackgroundView.addSubview(tokenNameLabel)
        whiteBackgroundView.addSubview(orderStateLabel)
        whiteBackgroundView.addSubview(withdrawTokenButton)
        whiteBackgroundView.addSubview(orderTotalAmountTitleLabel)
        whiteBackgroundView.addSubview(orderTotalAmountLabel)
        whiteBackgroundView.addSubview(itemBenefitLabel)
        whiteBackgroundView.addSubview(itemBenefitTitleLabel)
        whiteBackgroundView.addSubview(annualizedReturnTitleLabel)
        whiteBackgroundView.addSubview(annualizedReturnLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("DepositMarketTableViewCell销毁了")
    }
    //pragma MARK: 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        whiteBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(5)
            make.left.equalTo(contentView).offset(15)
            make.bottom.equalTo(contentView).offset(-5)
            make.right.equalTo(contentView.snp.right).offset(-15)
        }
        tokenIconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(whiteBackgroundView).offset(20)
            make.left.equalTo(whiteBackgroundView).offset(14)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        tokenNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(tokenIconImageView)
            make.left.equalTo(tokenIconImageView.snp.right).offset(8)
        }
        orderStateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(tokenNameLabel.snp.right).offset(6)
            make.centerY.equalTo(tokenIconImageView)
            let width = 6 + libraWalletTool.ga_widthForComment(content: localLanguage(keyString: "wallet_deposit_orders_order_state_title"), fontSize: 9, height: 16) + 6
            make.size.equalTo(CGSize.init(width: width, height: 16))
        }
        withdrawTokenButton.snp.makeConstraints { (make) in
            make.right.equalTo(whiteBackgroundView.snp.right).offset(-14)
            make.centerY.equalTo(tokenIconImageView)
            let width = 14 + libraWalletTool.ga_widthForComment(content: localLanguage(keyString: "wallet_deposit_orders_order_withdraw_button_title"), fontSize: 10, height: 20) + 14
            make.size.equalTo(CGSize.init(width: width, height: 20))
        }
        orderTotalAmountTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tokenIconImageView.snp.bottom).offset(22)
            make.left.equalTo(whiteBackgroundView).offset(14)
        }
        orderTotalAmountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(whiteBackgroundView).offset(14)
            make.top.equalTo(orderTotalAmountTitleLabel.snp.bottom).offset(10)
        }
        itemBenefitTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderTotalAmountTitleLabel)
            make.centerX.equalTo(whiteBackgroundView)
        }
        itemBenefitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(itemBenefitTitleLabel)
            make.centerY.equalTo(orderTotalAmountLabel)
        }
        annualizedReturnTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(itemBenefitTitleLabel)
            make.right.equalTo(whiteBackgroundView.snp.right).offset(-14)
        }
        annualizedReturnLabel.snp.makeConstraints { (make) in
            make.right.equalTo(whiteBackgroundView.snp.right).offset(-14)
            make.centerY.equalTo(orderTotalAmountLabel)
        }
    }
    // MARK: - 懒加载对象
    private lazy var whiteBackgroundView: UIView = {
        let view = UIView.init()
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    private lazy var tokenIconImageView: UIImageView = {
        let view = UIImageView.init()
        view.image = UIImage.init(named: "wallet_icon_default")
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.init(hex: "E0E0E0").cgColor
        view.layer.borderWidth = 0.5
        view.layer.masksToBounds = true
        return view
    }()
    lazy var tokenNameLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.init(hex: "333333")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 16), weight: UIFont.Weight.regular)
        label.text = "Test测试"
        return label
    }()
    lazy var orderStateLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.init(hex: "13B788")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 9), weight: UIFont.Weight.medium)
        label.backgroundColor = UIColor.init(hex: "13B788").alpha(0.06)
        label.text = localLanguage(keyString: "wallet_deposit_orders_order_state_title")
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    lazy var withdrawTokenButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle(localLanguage(keyString: "wallet_deposit_orders_order_withdraw_button_title"), for: UIControl.State.normal)
        button.setTitleColor(UIColor.init(hex: "7038FD"), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.regular)
        //        button.addTarget(self, action: #selector(buttonClick(button:)), for: UIControl.Event.touchUpInside)
        button.layer.borderColor = UIColor.init(hex: "7038FD").cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 9
        button.tag = 20
        return button
    }()
    lazy var orderTotalAmountTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.init(hex: "999999")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 10), weight: UIFont.Weight.regular)
        label.text = localLanguage(keyString: "wallet_deposit_orders_total_amount_title")
        return label
    }()
    lazy var orderTotalAmountLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.init(hex: "333333")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: UIFont.Weight.regular)
        label.text = "99999.999"
        return label
    }()
    lazy var itemBenefitTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.init(hex: "999999")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 10), weight: UIFont.Weight.regular)
        label.text = localLanguage(keyString: "wallet_deposit_orders_income_title")
        return label
    }()
    lazy var itemBenefitLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.init(hex: "333333")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: UIFont.Weight.regular)
        label.text = "99999.999"
        return label
    }()
    lazy var annualizedReturnTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor.init(hex: "999999")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 10), weight: UIFont.Weight.regular)
        label.text = localLanguage(keyString: "wallet_deposit_orders_annualized_return_title")
        return label
    }()
    lazy var annualizedReturnLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor.init(hex: "13B788")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: UIFont.Weight.bold)
        label.text = "999.999%"
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
    //    var model: TokenMappingListDataModel? {
    //        didSet {
    //            tokenNameLabel.text = model?.from_coin?.assert?.show_name
    //            if let iconName = model?.from_coin?.assert?.icon, iconName.isEmpty == false {
    //                let url = URL(string: iconName)
    //                transactionTypeImageView.kf.setImage(with: url, placeholder: UIImage.init(named: "wallet_icon_default"))
    //            }
    //            var unit = 1000000
    //            if model?.from_coin?.coin_type == "btc" {
    //                unit = 100000000
    //            }
    //            amountLabel.text = localLanguage(keyString: "wallet_transfer_balance_title") + getDecimalNumberAmount(amount: NSDecimalNumber.init(value: model?.from_coin?.assert?.amount ?? 0),
    //                                                                                                                  scale: 6,
    //                                                                                                                  unit: unit)
    //        }
    //    }
    var showSelectState: Bool? {
        didSet {
            //            if showSelectState == true {
            //                selectIndicatorImageView.alpha = 1
            //            } else {
            //                selectIndicatorImageView.alpha = 0
            //            }
        }
    }
}