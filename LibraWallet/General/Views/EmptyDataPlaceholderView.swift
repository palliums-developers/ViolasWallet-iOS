//
//  EmptyDataPlaceholderView.swift
//  HKWallet
//
//  Created by palliums on 2019/6/5.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit

class EmptyDataPlaceholderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = defaultBackgroundColor
        addSubview(topBackgroundImageView)
        addSubview(walletWhiteBackgroundView)

        walletWhiteBackgroundView.addSubview(indicatorImageView)
        walletWhiteBackgroundView.addSubview(tipLabel)
//        self.addSubview(descLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        topBackgroundImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(202)
        }
        walletWhiteBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(navigationBarHeight)
            make.left.right.bottom.equalTo(self)
        }
        indicatorImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(walletWhiteBackgroundView)
            make.bottom.equalTo(walletWhiteBackgroundView.snp.centerY).offset(-55)
        }
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(walletWhiteBackgroundView)
            make.top.equalTo(indicatorImageView.snp.bottom).offset(73)
        }
//        descLabel.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self)
//            make.top.equalTo(tipLabel.snp.bottom).offset(7)
//        }
    }
    internal lazy var indicatorImageView: UIImageView = {
        return UIImageView()
    }()
    internal lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hex: "263C4E")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: UIFont.Weight.regular)
//        label.font = PingFangRegular(15)
//        label.textColor = twLightGrayColor
        return label
    }()
//    internal lazy var descLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.init(hex: "D3D7E7")
//        label.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.regular)
//        return label
//    }()
    private lazy var topBackgroundImageView : UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "navigation_background")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private lazy var walletWhiteBackgroundView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        return view
    }()
    var emptyImageName:String? {
        didSet{
            indicatorImageView.image = UIImage.init(named: emptyImageName ?? "")
        }
    }
    var tipString:String? {
        didSet{
            tipLabel.text = tipString
        }
    }
//    var descString:String? {
//        didSet{
//            descLabel.text = descString
//        }
//    }
}