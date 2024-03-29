//
//  LoanQuestionTableViewHeaderView.swift
//  ViolasWallet
//
//  Created by wangyingdong on 2020/8/31.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit
protocol LoanQuestionTableViewHeaderViewDelegate: NSObjectProtocol {
    func showQuestions(header: LoanQuestionTableViewHeaderView)
}
class LoanQuestionTableViewHeaderView: UITableViewHeaderFooterView {
    weak var delegate: LoanQuestionTableViewHeaderViewDelegate?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.init(hex: "F7F7F9")
        contentView.addSubview(showButton)
        showButton.addSubview(itemTitleLabel)
        showButton.addSubview(itemIndicatorImageView)
        showButton.addSubview(itemDetailImageView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("LoanQuestionTableViewHeaderView销毁了")
    }
    //pragma MARK: 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        showButton.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView.snp.right).offset(-15)
            make.top.bottom.equalTo(contentView)
        }
        itemTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(showButton).offset(15)
            make.left.equalTo(showButton).offset(13)
        }
        itemIndicatorImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(itemTitleLabel)
            make.left.equalTo(itemTitleLabel.snp.right).offset(3)
            make.size.equalTo(CGSize.init(width: 14, height: 14))
        }
        itemDetailImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(itemTitleLabel)
            make.right.equalTo(showButton.snp.right).offset(-12)
            make.size.equalTo(CGSize.init(width: 12, height: 12))
        }
    }
    // MARK: - 懒加载对象
    lazy var itemTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.init(hex: "5C5C5C")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: UIFont.Weight.medium)
        label.text = localLanguage(keyString: "wallet_bank_loan_question_title")
        return label
    }()
    private lazy var itemIndicatorImageView : UIImageView = {
        let imageView = UIImageView.init()
        imageView.layer.cornerRadius = 7
        imageView.layer.masksToBounds = true
        imageView.image = UIImage.init(named: "wallet_bank_deposit_questions")
        return imageView
    }()
    private lazy var itemDetailImageView : UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "cell_detail")
        return imageView
    }()
    private lazy var showButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(buttonClick(button:)), for: UIControl.Event.touchUpInside)
        button.tag = 20
        return button
    }()
    @objc func buttonClick(button: UIButton) {
        self.delegate?.showQuestions(header: self)
    }
    var showQuestions: Bool? {
        didSet {
            if showQuestions == true {
                self.itemDetailImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            } else {
                self.itemDetailImageView.transform = CGAffineTransform.identity
            }
        }
    }
}
