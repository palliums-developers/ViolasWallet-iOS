//
//  ViolasTransferView.swift
//  ViolasWallet
//
//  Created by palliums on 2019/11/14.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit
protocol ViolasTransferViewDelegate: NSObjectProtocol {
    func scanAddressQRcode()
    func chooseAddress()
    func confirmTransfer(amount: UInt64, address: String, fee: UInt64)
}
class ViolasTransferView: UIView {
    weak var delegate: ViolasTransferViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(walletWhiteBackgroundView)
        
        walletWhiteBackgroundView.addSubview(amountTitleLabel)
        walletWhiteBackgroundView.addSubview(amountTextField)
        walletWhiteBackgroundView.addSubview(walletBalanceLabel)
        
        walletWhiteBackgroundView.addSubview(addressTitleLabel)
        walletWhiteBackgroundView.addSubview(addressTextField)
        walletWhiteBackgroundView.addSubview(addressContactButton)

        walletWhiteBackgroundView.addSubview(transferFeeTitleLabel)

        walletWhiteBackgroundView.addSubview(transferSpeedLeftTitleLabel)
        walletWhiteBackgroundView.addSubview(transferSpeedRightTitleLabel)
        walletWhiteBackgroundView.addSubview(transferFeeLabel)
        walletWhiteBackgroundView.addSubview(transferFeeSlider)

        walletWhiteBackgroundView.addSubview(confirmButton)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("ViolasTransferView销毁了")
    }
    //MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self)
        }
        walletWhiteBackgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.height.equalTo((444 * ratio))
            make.top.equalTo(scrollView).offset(30)
        }
        amountTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(amountTextField.snp.top).offset(-7)
            make.left.equalTo(walletWhiteBackgroundView).offset(22)
        }
        amountTextField.snp.makeConstraints { (make) in
            make.top.equalTo(walletWhiteBackgroundView).offset(52)
            make.left.equalTo(walletWhiteBackgroundView).offset(15)
            make.right.equalTo(walletWhiteBackgroundView.snp.right).offset(-15)
            make.height.equalTo(48)
        }
        walletBalanceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(amountTextField.snp.top).offset(-7)
            make.right.equalTo(walletWhiteBackgroundView.snp.right).offset(-19)
        }
        addressTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(addressTextField .snp.top).offset(-7)
            make.left.equalTo(walletWhiteBackgroundView).offset(22)
        }
        addressTextField.snp.makeConstraints { (make) in
            make.top.equalTo(amountTextField.snp.bottom).offset(50)
            make.left.equalTo(walletWhiteBackgroundView).offset(15)
            make.right.equalTo(walletWhiteBackgroundView).offset(-15)
            make.height.equalTo(48)
        }
        addressContactButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(addressTextField.snp.top).offset(-7)
            make.right.equalTo(walletWhiteBackgroundView.snp.right).offset(-19)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
//        addressSpaceLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(addressContactButton.snp.bottom).offset(10)
//            make.left.equalTo(walletWhiteBackgroundView).offset(21)
//            make.right.equalTo(walletWhiteBackgroundView.snp.right).offset(-19)
//            make.height.equalTo(1)
//        }
//
//        amountSpaceLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(addressSpaceLabel.snp.bottom).offset(83)
//            make.left.equalTo(walletWhiteBackgroundView).offset(21)
//            make.right.equalTo(walletWhiteBackgroundView.snp.right).offset(-19)
//            make.height.equalTo(1)
//        }
        transferFeeTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addressTextField.snp.bottom).offset(27)
            make.left.equalTo(walletWhiteBackgroundView).offset(15)
        }
        transferSpeedLeftTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.transferFeeSlider.snp.top).offset(-4)
            make.left.equalTo(self.transferFeeSlider.snp.left)
        }
        transferSpeedRightTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.transferFeeSlider.snp.top).offset(-4)
            make.right.equalTo(self.transferFeeSlider.snp.right)
        }
        transferFeeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.transferFeeSlider.snp.bottom).offset(6)
            make.left.equalTo(walletWhiteBackgroundView).offset(15)
        }
        transferFeeSlider.snp.makeConstraints { (make) in
            make.top.equalTo(addressTextField.snp.bottom).offset(78)
            make.left.equalTo(walletWhiteBackgroundView).offset(15)
            make.right.equalTo(walletWhiteBackgroundView).offset(-15)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(walletWhiteBackgroundView.snp.bottom).offset(-51)
            make.left.equalTo(walletWhiteBackgroundView).offset(54)
            make.right.equalTo(walletWhiteBackgroundView.snp.right).offset(-54)
            make.height.equalTo(40)
        }
        scrollView.contentSize = CGSize.init(width: mainWidth, height: walletWhiteBackgroundView.frame.maxY + 10)
    }
    //MARK: - 懒加载对象
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView.init()
        return scrollView
    }()
    
    private lazy var walletWhiteBackgroundView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        // 定义阴影颜色
        view.layer.shadowColor = UIColor.init(hex: "3D3949").cgColor
        // 阴影的模糊半径
        view.layer.shadowRadius = 3
        // 阴影的偏移量
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        // 阴影的透明度，默认为0，不设置则不会显示阴影****
        view.layer.shadowOpacity = 0.1
        return view
    }()
    lazy var amountTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.init(hex: "3C3848")
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "---"
        return label
    }()
    lazy var amountTextField: WYDTextField = {
        let textField = WYDTextField.init()
        textField.textAlignment = NSTextAlignment.left
        textField.textColor = UIColor.init(hex: "333333")
        textField.font = UIFont.init(name: "DIN Alternate Bold", size: 14)
        textField.attributedPlaceholder = NSAttributedString(string: localLanguage(keyString: "wallet_transfer_amount_textfield_placeholder"),
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: "C4C3C7"),NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        textField.delegate = self
        textField.keyboardType = .decimalPad
        textField.tintColor = DefaultGreenColor
        textField.layer.borderColor = UIColor.init(hex: "D8D7DA").cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 16
        let holderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 7, height: 48))
        textField.leftView = holderView
        textField.leftViewMode = .always
        return textField
    }()
    lazy var walletBalanceLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.init(hex: "3C3848")
//        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.font = UIFont.init(name: "DIN Alternate Bold", size: 14)
        label.text = localLanguage(keyString: "wallet_transfer_balance_title") + " 0.00"
        return label
    }()
    lazy var addressTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.init(hex: "3C3848")
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = localLanguage(keyString: "wallet_transfer_address_title")
        return label
    }()
    lazy var addressTextField: UITextField = {
        let textField = UITextField.init()
        textField.textAlignment = NSTextAlignment.left
        textField.textColor = UIColor.init(hex: "333333")
        textField.attributedPlaceholder = NSAttributedString(string: localLanguage(keyString: "wallet_transfer_address_violas_textfield_placeholder"),
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: "C4C3C7"),NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        textField.keyboardType = .default
        textField.tintColor = DefaultGreenColor
        textField.layer.borderColor = UIColor.init(hex: "D8D7DA").cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 16
        let holderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 7, height: 48))
        textField.leftView = holderView
        textField.leftViewMode = .always
        let rightView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 31.5, height: 48))
        rightView.addSubview(addressScanButton)
        textField.rightView = rightView
        textField.rightViewMode = .always
        return textField
    }()
    lazy var addressScanButton: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 28, height: 48))
        button.setImage(UIImage.init(named: "scan"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(buttonClick(button:)), for: UIControl.Event.touchUpInside)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        button.tag = 10
        return button
    }()
    lazy var addressContactButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage.init(named: "contact_address"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(buttonClick(button:)), for: UIControl.Event.touchUpInside)
        button.tag = 15
        return button
    }()
    lazy var transferFeeTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(hex: "3C3848")
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = localLanguage(keyString: "wallet_transfer_transaction_fee_title")
        return label
    }()
    lazy var transferFeeSlider: TransferFeeSliderCustom = {
        let slide = TransferFeeSliderCustom.init()
        slide.value = 0.2
        slide.setThumbImage(UIImage.init(named: "slide_button"), for: UIControl.State.normal)
        slide.setThumbImage(UIImage.init(named: "slide_button"), for: UIControl.State.highlighted)
        slide.setMinimumTrackImage(UIImage().imageWithColor(color: UIColor.init(hex: "9339F3")), for: UIControl.State.normal)
        slide.setMinimumTrackImage(UIImage().imageWithColor(color: UIColor.init(hex: "9339F3")), for: UIControl.State.highlighted)
        slide.setMaximumTrackImage(UIImage().imageWithColor(color: UIColor.init(hex: "F5F5F5")), for: UIControl.State.normal)
        slide.setMaximumTrackImage(UIImage().imageWithColor(color: UIColor.init(hex: "F5F5F5")), for: UIControl.State.highlighted)
        slide.addTarget(self, action: #selector(slideValueDidChange(slide:)
            ), for: UIControl.Event.valueChanged)
        return slide
    }()
    lazy var transferSliderBackground : UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "slider_background")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var transferSpeedLeftTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(hex: "3C3848")
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = localLanguage(keyString: "wallet_transfer_transaction_fee_least_title")
        return label
    }()
    lazy var transferSpeedRightTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(hex: "263C4E")
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = localLanguage(keyString: "wallet_transfer_transaction_fee_max_title")
        return label
    }()
    lazy var transferFeeLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.init(hex: "3C3848")
//        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.font = UIFont.init(name: "DIN Alternate Bold", size: 10)
        label.textAlignment = NSTextAlignment.center
        label.text = "0.00"
        return label
    }()
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle(localLanguage(keyString: "wallet_transfer_confirm_button_title"), for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        button.addTarget(self, action: #selector(buttonClick(button:)), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor.init(hex: "15C794")
        let width = UIScreen.main.bounds.width - 69 - 69

        button.layer.insertSublayer(colorGradualChange(size: CGSize.init(width: width, height: 40)), at: 0)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    @objc func buttonClick(button: UIButton) {
        self.amountTextField.resignFirstResponder()
        self.addressTextField.resignFirstResponder()
        self.transferFeeSlider.resignFirstResponder()
        if button.tag == 10 {
            // 扫描地址
            self.delegate?.scanAddressQRcode()
        } else if button.tag == 15 {
            // 常用地址
            self.delegate?.chooseAddress()
        } else {
            // 金额不为空检查
            guard let amountString = self.amountTextField.text, amountString.isEmpty == false else {
                self.makeToast(LibraWalletError.WalletTransfer(reason: .amountEmpty).localizedDescription,
                               position: .center)
                return
            }
            // 金额是否纯数字检查
            guard isPurnDouble(string: amountString) == true else {
                self.makeToast(LibraWalletError.WalletTransfer(reason: .amountInvalid).localizedDescription,
                               position: .center)
                return
            }
            // 转换数字
            let amount = NSDecimalNumber.init(string: amountString)
            guard amount != 0 else {
                self.makeToast(LibraWalletError.WalletTransfer(reason: .violasAmountLeast).localizedDescription,
                               position: .center)
                return
            }
            // 手续费转换
            let feeString = self.transferFeeLabel.text
            let fee = NSDecimalNumber.init(string: "\(feeString?.split(separator: " ").first ?? "0")").multiplying(by: NSDecimalNumber.init(value: 1000000))
            // 金额大于我的金额
            var unit = 1000000
            if wallet?.tokenType == .BTC {
                unit = 100000000
            }
            let numberConfig = NSDecimalNumberHandler.init(roundingMode: .down,
                                                           scale: unit == 1000000 ? 6:8,
                                                           raiseOnExactness: false,
                                                           raiseOnOverflow: false,
                                                           raiseOnUnderflow: false,
                                                           raiseOnDivideByZero: false)
            let balance = NSDecimalNumber.init(value: wallet?.tokenBalance ?? 0).dividing(by: NSDecimalNumber.init(value: unit), withBehavior: numberConfig)
            // 平台币
            guard (amount.doubleValue) <= balance.doubleValue else {
                self.makeToast(LibraWalletError.WalletTransfer(reason: .amountOverload).localizedDescription,
                               position: .center)
                return
            }
            // 地址拆包检查
            guard let address = self.addressTextField.text, address.isEmpty == false else {
                self.makeToast(LibraWalletError.WalletTransfer(reason: .addressEmpty).localizedDescription,
                              position: .center)
               return
            }
            // 是否有效地址
            guard ViolasManager.isValidViolasAddress(address: address) else {
                self.makeToast(LibraWalletError.WalletTransfer(reason: .addressInvalid).localizedDescription,
                               position: .center)
                return
            }
            // 检查是否向自己转账
            guard address != self.wallet?.tokenAddress else {
                self.makeToast(LibraWalletError.WalletTransfer(reason: .transferToSelf).localizedDescription,
                               position: .center)
                return
            }
            // 确认提交
            self.delegate?.confirmTransfer(amount: amount.multiplying(by: NSDecimalNumber.init(value: unit)).uint64Value, address: address, fee: fee.uint64Value)
        }
    }
    lazy var backgroundLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: mainWidth, height: mainHeight)
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0, y: 1)
        gradientLayer.locations = [0.5,1.0]
        gradientLayer.colors = [UIColor.init(hex: "363E57").cgColor, UIColor.init(hex: "101633").cgColor]
        return gradientLayer
    }()
    var toastView: ToastView? {
        let toast = ToastView.init()
        return toast
    }
    var originFee: Int64?
    
    @objc func slideValueDidChange(slide: UISlider) {
        let numberConfig = NSDecimalNumberHandler.init(roundingMode: .down,
                                                       scale: 6,
                                                       raiseOnExactness: false,
                                                       raiseOnOverflow: false,
                                                       raiseOnUnderflow: false,
                                                       raiseOnDivideByZero: false)
        let region = NSDecimalNumber.init(value: 0.0001).subtracting(NSDecimalNumber.init(value: 0))
        let fee = region.multiplying(by: NSDecimalNumber(value: slide.value)).adding(NSDecimalNumber.init(value: 0))
        let feeString = fee.multiplying(by: NSDecimalNumber.init(value: 1), withBehavior: numberConfig).stringValue
        transferFeeLabel.text = feeString + " " + (wallet?.tokenName ?? "")
    }
    var wallet: Token? {
        didSet {
            guard let model = wallet else {
                return
            }
            var unit = 1000000
            if model.tokenType == .BTC {
                unit = 100000000
            }
            amountTitleLabel.text = wallet?.tokenName
            let balance = getDecimalNumberAmount(amount: NSDecimalNumber.init(value: (model.tokenBalance )),
                                                 scale: 6,
                                                 unit: unit)
            walletBalanceLabel.text = localLanguage(keyString: "wallet_transfer_balance_title") + balance + " " + model.tokenName
            let numberConfig = NSDecimalNumberHandler.init(roundingMode: .down,
                                                           scale: 6,
                                                           raiseOnExactness: false,
                                                           raiseOnOverflow: false,
                                                           raiseOnUnderflow: false,
                                                           raiseOnDivideByZero: false)
            let region = NSDecimalNumber.init(value: 0.0001).subtracting(NSDecimalNumber.init(value: 0))
            let fee = region.multiplying(by: NSDecimalNumber(value: 0.2)).adding(NSDecimalNumber.init(value: 0))
            let feeString = fee.multiplying(by: NSDecimalNumber.init(value: 1), withBehavior: numberConfig).stringValue
            transferFeeLabel.text = feeString + " " + (wallet?.tokenName ?? "")
        }
    }
    var sendViolasTokenState: Bool?
}
extension ViolasTransferView: UITextFieldDelegate {
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       guard let content = textField.text else {
           return true
       }
       let textLength = content.count + string.count - range.length
       if content.contains(".") {
           let firstContent = content.split(separator: ".").first?.description ?? "0"
           if (textLength - firstContent.count) < 8 {
               return true
           } else {
               return false
           }
       } else {
           return textLength <= ApplyTokenAmountLengthLimit
       }
   }
}
