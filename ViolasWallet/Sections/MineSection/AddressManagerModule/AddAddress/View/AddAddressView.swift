//
//  AddAddressView.swift
//  HKWallet
//
//  Created by palliums on 2019/7/25.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit
protocol AddAddressViewDelegate: NSObjectProtocol {
    func confirmAddAddress(address: String, remarks: String, type: String)
    func scanAddress()
//    func showTypeSelecter()
}
class AddAddressView: UIView {
    weak var delegate: AddAddressViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(remarksTitleLabel)
        addSubview(remarksTextField)
        addSubview(remarksSpaceLabel)
        
        addSubview(addressTitleLabel)
        addSubview(addressTextField)
        addSubview(scanAddressButton)
        addSubview(addressSpaceLabel)
        
        addSubview(typeTitleLabel)
        addSubview(violasAddressButton)
        addSubview(libraAddressButton)
        addSubview(bitcoinAddressButton)
            
        addSubview(confirmButton)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("AddAddressView销毁了")
    }
    //MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        remarksTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(remarksTextField)
            make.left.equalTo(self)
            make.right.equalTo(remarksSpaceLabel.snp.left)
        }
        remarksTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(remarksSpaceLabel.snp.top)
            make.left.right.equalTo(self.remarksSpaceLabel)
            make.height.equalTo(60)
        }
        remarksSpaceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(60)
            make.left.equalTo(self).offset(58)
            make.right.equalTo(self.snp.right).offset(-15)
            make.height.equalTo(0.5)
        }
        addressTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(addressTextField)
            make.left.equalTo(self)
            make.right.equalTo(addressSpaceLabel.snp.left)
        }
        addressTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(addressSpaceLabel.snp.top)
            make.left.equalTo(addressSpaceLabel)
            make.right.equalTo(scanAddressButton.snp.left)
            make.height.equalTo(60)
        }
        scanAddressButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(addressTextField)
            make.right.equalTo(self.addressSpaceLabel)
            make.size.equalTo(CGSize.init(width: 20, height: 60))
        }
        addressSpaceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(remarksSpaceLabel.snp.bottom).offset(60)
            make.left.equalTo(self).offset(58)
            make.right.equalTo(self.snp.right).offset(-15)
            make.height.equalTo(0.5)
        }
        typeTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(violasAddressButton)
            make.left.equalTo(self)
            make.right.equalTo(violasAddressButton.snp.left)
        }
        violasAddressButton.snp.makeConstraints { (make) in
            make.top.equalTo(addressSpaceLabel.snp.bottom).offset(21)
            make.left.equalTo(self).offset(58)
            make.width.equalTo(libraAddressButton)
            make.height.equalTo(28)
        }
        libraAddressButton.snp.makeConstraints { (make) in
            make.top.equalTo(addressSpaceLabel.snp.bottom).offset(21)
            make.left.equalTo(violasAddressButton.snp.right).offset(22)
            //            make.size.equalTo(CGSize.init(width: 100, height: 50))
            make.width.equalTo(bitcoinAddressButton)
            make.height.equalTo(28)
        }
        bitcoinAddressButton.snp.makeConstraints { (make) in
            make.top.equalTo(addressSpaceLabel.snp.bottom).offset(21)
            make.left.equalTo(libraAddressButton.snp.right).offset(22)
            //            make.size.equalTo(CGSize.init(width: 100, height: 50))
            let width = (mainWidth - 58 - 15 - 22 - 22) / 3
            make.width.equalTo(width)
            make.height.equalTo(28)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(addressSpaceLabel.snp.bottom).offset(137)
            make.left.equalTo(self).offset(69)
            make.right.equalTo(self.snp.right).offset(-69)
            make.height.equalTo(40)
        }
    }
    //MARK: - 懒加载对象
    
    lazy var remarksTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = UIColor.init(hex: "2E2E2E")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: .regular)
        label.text = localLanguage(keyString: "wallet_address_add_remarks_title")
        return label
    }()
    lazy var remarksTextField: UITextField = {
        let textField = UITextField.init()
        textField.textAlignment = NSTextAlignment.left
        textField.textColor = UIColor.init(hex: "3C3848")
        textField.attributedPlaceholder = NSAttributedString(string: localLanguage(keyString: "wallet_address_add_remarks_textfield_placeholder"),
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: "BABABA").alpha(0.3),NSAttributedString.Key.font: UIFont.systemFont(ofSize: adaptFont(fontSize: 14))])
        textField.tintColor = DefaultGreenColor
        textField.delegate = self
        return textField
    }()
    lazy var remarksSpaceLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = DefaultSpaceColor
        return label
    }()
    lazy var addressTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = UIColor.init(hex: "333333")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: .regular)
        label.text = localLanguage(keyString: "wallet_address_add_address_title")
        return label
    }()
    lazy var addressTextField: UITextField = {
        let textField = UITextField.init()
        textField.textAlignment = NSTextAlignment.left
        textField.textColor = UIColor.init(hex: "3C3848")
        textField.attributedPlaceholder = NSAttributedString(string: localLanguage(keyString: "wallet_address_add_address_textfield_placeholder"),
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: "BABABA").alpha(0.3),NSAttributedString.Key.font: UIFont.systemFont(ofSize: adaptFont(fontSize: 14))])
        textField.tintColor = DefaultGreenColor
        return textField
    }()
    lazy var scanAddressButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage.init(named: "scan"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(buttonClick(button:)), for: UIControl.Event.touchUpInside)
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = true
        button.tag = 20
        return button
    }()
    lazy var addressSpaceLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = DefaultSpaceColor
        return label
    }()
    lazy var typeTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = UIColor.init(hex: "333333")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: .regular)
        label.text = localLanguage(keyString: "wallet_address_add_type_title")
        return label
    }()
    lazy var violasAddressButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle(localLanguage(keyString: "Violas"), for: UIControl.State.normal)
        button.setTitleColor(UIColor.init(hex: "999999"), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: UIFont.Weight.regular)
        button.addTarget(self, action: #selector(buttonClick(button:)), for: UIControl.Event.touchUpInside)
        button.layer.backgroundColor = UIColor.init(hex: "F7F7F7").cgColor
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = true
        button.tag = 31
        return button
    }()
    lazy var libraAddressButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle(localLanguage(keyString: "Libra"), for: UIControl.State.normal)
        button.setTitleColor(UIColor.init(hex: "999999"), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: UIFont.Weight.regular)
        button.addTarget(self, action: #selector(buttonClick(button:)), for: UIControl.Event.touchUpInside)
        button.layer.backgroundColor = UIColor.init(hex: "F7F7F7").cgColor
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = true
        button.tag = 32
        return button
    }()
    lazy var bitcoinAddressButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle(localLanguage(keyString: "Bitcoin"), for: UIControl.State.normal)
        button.setTitleColor(UIColor.init(hex: "999999"), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: UIFont.Weight.regular)
        button.addTarget(self, action: #selector(buttonClick(button:)), for: UIControl.Event.touchUpInside)
        button.layer.backgroundColor = UIColor.init(hex: "F7F7F7").cgColor
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = true
        button.tag = 33
        return button
    }()
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle(localLanguage(keyString: "wallet_address_add_confirm_button_title"), for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: UIFont.Weight.regular)
        button.addTarget(self, action: #selector(buttonClick(button:)), for: UIControl.Event.touchUpInside)
        let width = UIScreen.main.bounds.width - 69 - 69
        button.layer.insertSublayer(colorGradualChange(size: CGSize.init(width: width, height: 40)), at: 0)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.tag = 10
        return button
    }()
    @objc func buttonClick(button: UIButton) {
        if button.tag == 10 {
            self.remarksTextField.resignFirstResponder()
            self.addressTextField.resignFirstResponder()
            guard let remarks = remarksTextField.text else {
                self.makeToast(LibraWalletError.WalletAddAddress(reason: .remarksInvalidError).localizedDescription,
                               position: .center)
                return
            }
            guard remarks.isEmpty == false else {
                self.makeToast(LibraWalletError.WalletAddAddress(reason: .remarksEmptyError).localizedDescription,
                               position: .center)
                return
            }
            guard let address = addressTextField.text else {
                self.makeToast(LibraWalletError.WalletAddAddress(reason: .addressInvalidError).localizedDescription,
                               position: .center)
                return
            }
            guard address.isEmpty == false else {
                self.makeToast(LibraWalletError.WalletAddAddress(reason: .addressEmptyError).localizedDescription,
                               position: .center)
                return
            }
            guard let index = self.lastSelectIndex else {
                self.makeToast(LibraWalletError.WalletAddAddress(reason: .addressTypeInvalidError).localizedDescription,
                               position: .center)
                return
            }
            var type = ""
            if index == 31 {
                guard ViolasManager.isValidViolasAddress(address: address) == true else {
                    self.makeToast(LibraWalletError.WalletAddAddress(reason: .violasAddressInvalidError).localizedDescription,
                                   position: .center)
                    return
                }
                type = "1"
            } else if index == 32 {
                guard DiemManager.isValidDiemAddress(address: address) == true else {
                    self.makeToast(LibraWalletError.WalletAddAddress(reason: .libraAddressInvalidError).localizedDescription,
                                   position: .center)
                    return
                }
                type = "0"
            } else if index == 33 {
                guard BTCManager.isValidBTCAddress(address: address) == true else {
                    self.makeToast(LibraWalletError.WalletAddAddress(reason: .btcAddressInvalidError).localizedDescription,
                                   position: .center)
                    return
                }
                type = "2"
            } else {
                self.makeToast(LibraWalletError.WalletAddAddress(reason: .addressTypeInvalidError).localizedDescription,
                               position: .center)
            }
            // 添加地址
            self.delegate?.confirmAddAddress(address: address, remarks: remarks, type: type)
        } else if button.tag == 20 {
            self.delegate?.scanAddress()
        } else if button.tag == 31 {
            setDefaultType()
            lastSelectIndex = button.tag
            button.layer.backgroundColor = UIColor.init(hex: "4730A7").cgColor
            button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        } else if button.tag == 32 {
            setDefaultType()
            lastSelectIndex = button.tag
            button.layer.backgroundColor = UIColor.init(hex: "4730A7").cgColor
            button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        } else if button.tag == 33 {
            setDefaultType()
            lastSelectIndex = button.tag
            button.layer.backgroundColor = UIColor.init(hex: "4730A7").cgColor
            button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }
    }
    func setDefaultType() {
        if let tag = lastSelectIndex {
            (self.viewWithTag(tag) as! UIButton).setTitleColor(UIColor.init(hex: "999999"), for: UIControl.State.normal)
            (self.viewWithTag(tag) as! UIButton).layer.backgroundColor = UIColor.init(hex: "F7F7F7").cgColor
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
    var lastSelectIndex: Int?
}
extension AddAddressView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let content = textField.text else {
            return true
        }
        let textLength = content.count + string.count - range.length
        
        return textLength <= addressRemarksLimit
    }
}
