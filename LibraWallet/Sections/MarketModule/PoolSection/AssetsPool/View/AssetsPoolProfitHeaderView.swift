//
//  AssetsPoolProfitHeaderView.swift
//  LibraWallet
//
//  Created by wangyingdong on 2020/12/7.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit

class AssetsPoolProfitHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        //        addSubview(headerBackground)
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(titleLabel)
        backgroundImageView.addSubview(describeLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("AssetsPoolProfitHeaderView销毁了")
    }
    // MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImageView).offset(13)
            make.left.equalTo(backgroundImageView).offset(54)
        }
        describeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundImageView).offset(54)
            make.right.equalTo(backgroundImageView.snp.right).offset(-20)
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(-9)
        }
    }
    // MARK: - 懒加载对象
    lazy var backgroundImageView : UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "pool_yield_farming_background")
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.init(hex: "FB8F0B")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: UIFont.Weight.semibold)
        label.text = localLanguage(keyString: "wallet_market_assets_pool_yield_farming_title")
        return label
    }()
    lazy var describeLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.init(hex: "333333")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 10), weight: UIFont.Weight.regular)
        label.text = localLanguage(keyString: "wallet_market_assets_pool_yield_farming_describe") + "---"
        return label
    }()
}