//
//  TransactionDetailView.swift
//  ViolasWallet
//
//  Created by wangyingdong on 2020/6/5.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit

class TransactionDetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hex: "F7F7F9")
        addSubview(topBackgroundImageView)
        addSubview(transactionBackgroundImageView)
        transactionBackgroundImageView.addSubview(transactionStateImageView)
        transactionBackgroundImageView.addSubview(transactionStateLabel)
        transactionBackgroundImageView.addSubview(transactionDateLabel)
        transactionBackgroundImageView.addSubview(tableView)
        addSubview(bottomBackgroundImageView)
        addSubview(checkOnlineButton)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("TransactionDetailView销毁了")
    }
    //MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        topBackgroundImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo((153 * ratio))
        }
        transactionBackgroundImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(navigationBarHeight)
            make.left.equalTo(38)
            make.right.equalTo(self.snp.right).offset(-38)
            make.height.equalTo(404)
        }
        transactionStateImageView.snp.makeConstraints { (make) in
            make.top.equalTo(transactionBackgroundImageView).offset(40)
            make.size.equalTo(CGSize.init(width: 38, height: 38))
            make.centerX.equalTo(transactionBackgroundImageView)
        }
        transactionStateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(transactionStateImageView.snp.bottom).offset(14)
            make.centerX.equalTo(transactionBackgroundImageView)
            make.left.equalTo(transactionBackgroundImageView).offset(10)
            make.right.equalTo(transactionBackgroundImageView.snp.right).offset(-10)
        }
        transactionDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(transactionStateLabel.snp.bottom).offset(18)
            make.centerX.equalTo(transactionBackgroundImageView)
            make.left.equalTo(transactionBackgroundImageView).offset(10)
            make.right.equalTo(transactionBackgroundImageView.snp.right).offset(-10)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(transactionBackgroundImageView).offset(190)
            make.left.right.equalTo(transactionBackgroundImageView)
            make.bottom.equalTo(transactionBackgroundImageView.snp.bottom)
        }
        bottomBackgroundImageView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
        }
        checkOnlineButton.snp.makeConstraints { (make) in
            make.left.right.centerX.equalTo(self)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
    }
    private lazy var topBackgroundImageView : UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "transaction_detail_navigationbar_background")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private lazy var transactionBackgroundImageView : UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "transaction_detail_background")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var transactionStateImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "wallet_icon_default")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var transactionStateLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.init(hex: "00D1AF")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 16), weight: UIFont.Weight.semibold)
        label.text = "---"
        return label
    }()
    lazy var transactionDateLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.init(hex: "999999")
        label.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 12), weight: UIFont.Weight.regular)
        label.text = "---"
        return label
    }()
    lazy var borderLayer: CAShapeLayer = {
        let border = CAShapeLayer.init()
        //虚线的颜色
        border.strokeColor = UIColor.init(hex: "3C3848").alpha(0.5).cgColor
        //填充的颜色
        border.fillColor = UIColor.clear.cgColor
        let path = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: mainWidth - 64, height: 36), cornerRadius: 2)
        //设置路径
        border.path = path.cgPath
        border.frame = CGRect.init(x: 0, y: 0, width: mainWidth - 64, height: 36)
        //虚线的宽度
        border.lineWidth = 1
        //虚线的间隔
        border.lineDashPattern = [3,1.5]
        return border
    }()
    //MARK: - 懒加载对象
    lazy var tableView: UITableView = {
        let tableView = UITableView.init()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        tableView.backgroundColor = UIColor.white//defaultBackgroundColor
        tableView.isScrollEnabled = false
        tableView.register(TransactionDetailTableViewCell.classForCoder(), forCellReuseIdentifier: "AmountCell")
        tableView.register(TransactionDetailTableViewCell.classForCoder(), forCellReuseIdentifier: "AddressCell")
        tableView.register(TransactionDetailTableViewCell.classForCoder(), forCellReuseIdentifier: "NormalCell")
        return tableView
    }()
    private lazy var bottomBackgroundImageView : UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "transaction_detail_bottom_background")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var checkOnlineButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle(localLanguage(keyString: "wallet_transaction_detail_explorer_check_title"), for: UIControl.State.normal)
        button.setTitleColor(UIColor.init(hex: "7038FD"), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: adaptFont(fontSize: 14), weight: UIFont.Weight.regular)
        //        button.addTarget(self, action: #selector(buttonClick(button:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    var violasTransaction: ViolasDataModel? {
        didSet {
            guard let model = violasTransaction else {
                return
            }
            transactionDateLabel.text = timestampToDateString(timestamp: model.expiration_time ?? 0, dateFormat: "yyyy-MM-dd HH:mm:ss")
            if model.status == "Executed" {
                switch model.type {
                case "ADD_CURRENCY_TO_ACCOUNT":
                    //ADD_CURRENCY_TO_ACCOUNT
                    print("0")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_publish_success_title")
                case "ADD_VALIDATOR":
                    //ADD_VALIDATOR
                    print("1")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "BURN":
                    //BURN
                    print("2")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "BURN_TXN_FEES":
                    //BURN_TXN_FEES
                    print("3")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "CANCEL_BURN":
                    //CANCEL_BURN
                    print("4")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "CREATE_CHILD_VASP_ACCOUNT":
                    //CREATE_CHILD_VASP_ACCOUNT
                    print("5")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "CREATE_DESIGNATED_DEALER":
                    //CREATE_DESIGNATED_DEALER
                    print("6")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "CREATE_PARENT_VASP_ACCOUNT":
                    //CREATE_PARENT_VASP_ACCOUNT
                    print("7")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "CREATE_VALIDATOR_ACCOUNT":
                    //CREATE_VALIDATOR_ACCOUNT
                    print("8")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "EMPTY_SCRIPT":
                    //EMPTY_SCRIPT
                    print("9")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "FREEZE_ACCOUNT":
                    //FREEZE_ACCOUNT
                    print("10")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "MINT":
                    //MINT
                    print("13")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_mint_authority_success_title")
                case "MODIFY_PUBLISHING_OPTION":
                    //MODIFY_PUBLISHING_OPTION
                    print("14")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "PEER_TO_PEER_WITH_METADATA":
                    //PEER_TO_PEER_WITH_METADATA
                    print("15")
                    if model.transaction_type == 0 {
                        // 转账
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_transfer_success_title")
                    } else {
                        // 收款
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_receive_success_title")
                    }
                case "PREBURN":
                    //PREBURN
                    print("16")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "PUBLISH_SHARED_ED25519_PUBLIC_KEY":
                    //PUBLISH_SHARED_ED25519_PUBLIC_KEY
                    print("17")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "REGISTER_PREBURNER":
                    //REGISTER_PREBURNER
                    print("18")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "REGISTER_VALIDATOR":
                    //REGISTER_VALIDATOR
                    print("19")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "REMOVE_ASSOCIATION_PRIVILEGE":
                    //REMOVE_ASSOCIATION_PRIVILEGE
                    print("20")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "REMOVE_VALIDATOR":
                    //REMOVE_VALIDATOR
                    print("21")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "ROTATE_AUTHENTICATION_KEY":
                    //ROTATE_AUTHENTICATION_KEY
                    print("22")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "ROTATE_AUTHENTICATION_KEY_WITH_NONCE":
                    //ROTATE_AUTHENTICATION_KEY_WITH_NONCE
                    print("23")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "ROTATE_BASE_URL":
                    //ROTATE_BASE_URL
                    print("24")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "ROTATE_COMPLIANCE_PUBLIC_KEY":
                    //ROTATE_COMPLIANCE_PUBLIC_KEY
                    print("25")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "ROTATE_CONSENSUS_PUBKEY":
                    //ROTATE_CONSENSUS_PUBKEY
                    print("26")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "ROTATE_SHARED_ED25519_PUBLIC_KEY":
                    //ROTATE_SHARED_ED25519_PUBLIC_KEY
                    print("27")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "ROTATE_VALIDATOR_CONFIG":
                    //ROTATE_VALIDATOR_CONFIG
                    print("28")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "TIERED_MINT":
                    //TIERED_MINT
                    print("29")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "UNFREEZE_ACCOUNT":
                    //UNFREEZE_ACCOUNT
                    print("30")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "UNMINT_LBR":
                    //UNMINT_LBR
                    print("31")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "UPDATE_EXCHANGE_RATE":
                    //UPDATE_EXCHANGE_RATE
                    print("32")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "UPDATE_LIBRA_VERSION":
                    //UPDATE_LIBRA_VERSION
                    print("33")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "UPDATE_MINTING_ABILITY":
                    //UPDATE_MINTING_ABILITY
                    print("34")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "CHANGE_SET":
                    //CHANGE_SET
                    print("97")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "BLOCK_METADATA":
                    //BLOCK_METADATA
                    print("98")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                case "UNKNOWN":
                    //UNKNOWN
                    print("100")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                default:
                    print("others")
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                }
                transactionStateImageView.image = UIImage.init(named: "transaction_detail_finish")
            } else {
                transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_transaction_failed_title")
                transactionStateLabel.textColor = UIColor.init(hex: "F55753")
                transactionStateImageView.image = UIImage.init(named: "transaction_detail_failed")
            }
        }
    }
    var libraTransaction: LibraDataModel? {
        didSet {
            guard let model = libraTransaction else {
                return
            }
            transactionDateLabel.text = timestampToDateString(timestamp: model.expiration_time ?? 0, dateFormat: "yyyy-MM-dd HH:mm:ss")
            if model.status == "Executed" {
                if model.status == "Executed" {
                    switch model.type {
                    case "ADD_CURRENCY_TO_ACCOUNT":
                        //ADD_CURRENCY_TO_ACCOUNT
                        print("0")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_publish_success_title")
                    case "ADD_VALIDATOR":
                        //ADD_VALIDATOR
                        print("1")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "BURN":
                        //BURN
                        print("2")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "BURN_TXN_FEES":
                        //BURN_TXN_FEES
                        print("3")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "CANCEL_BURN":
                        //CANCEL_BURN
                        print("4")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "CREATE_CHILD_VASP_ACCOUNT":
                        //CREATE_CHILD_VASP_ACCOUNT
                        print("5")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "CREATE_DESIGNATED_DEALER":
                        //CREATE_DESIGNATED_DEALER
                        print("6")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "CREATE_PARENT_VASP_ACCOUNT":
                        //CREATE_PARENT_VASP_ACCOUNT
                        print("7")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "CREATE_VALIDATOR_ACCOUNT":
                        //CREATE_VALIDATOR_ACCOUNT
                        print("8")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "EMPTY_SCRIPT":
                        //EMPTY_SCRIPT
                        print("9")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "FREEZE_ACCOUNT":
                        //FREEZE_ACCOUNT
                        print("10")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "MINT":
                        //MINT
                        print("13")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_mint_authority_success_title")
                    case "MODIFY_PUBLISHING_OPTION":
                        //MODIFY_PUBLISHING_OPTION
                        print("14")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "PEER_TO_PEER_WITH_METADATA":
                        //PEER_TO_PEER_WITH_METADATA
                        print("15")
                        if model.transaction_type == 0 {
                            // 转账
                            transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_transfer_success_title")
                        } else {
                            // 收款
                            transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_receive_success_title")
                        }
                    case "PREBURN":
                        //PREBURN
                        print("16")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "PUBLISH_SHARED_ED25519_PUBLIC_KEY":
                        //PUBLISH_SHARED_ED25519_PUBLIC_KEY
                        print("17")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "REGISTER_PREBURNER":
                        //REGISTER_PREBURNER
                        print("18")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "REGISTER_VALIDATOR":
                        //REGISTER_VALIDATOR
                        print("19")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "REMOVE_ASSOCIATION_PRIVILEGE":
                        //REMOVE_ASSOCIATION_PRIVILEGE
                        print("20")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "REMOVE_VALIDATOR":
                        //REMOVE_VALIDATOR
                        print("21")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "ROTATE_AUTHENTICATION_KEY":
                        //ROTATE_AUTHENTICATION_KEY
                        print("22")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "ROTATE_AUTHENTICATION_KEY_WITH_NONCE":
                        //ROTATE_AUTHENTICATION_KEY_WITH_NONCE
                        print("23")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "ROTATE_BASE_URL":
                        //ROTATE_BASE_URL
                        print("24")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "ROTATE_COMPLIANCE_PUBLIC_KEY":
                        //ROTATE_COMPLIANCE_PUBLIC_KEY
                        print("25")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "ROTATE_CONSENSUS_PUBKEY":
                        //ROTATE_CONSENSUS_PUBKEY
                        print("26")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "ROTATE_SHARED_ED25519_PUBLIC_KEY":
                        //ROTATE_SHARED_ED25519_PUBLIC_KEY
                        print("27")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "ROTATE_VALIDATOR_CONFIG":
                        //ROTATE_VALIDATOR_CONFIG
                        print("28")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "TIERED_MINT":
                        //TIERED_MINT
                        print("29")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "UNFREEZE_ACCOUNT":
                        //UNFREEZE_ACCOUNT
                        print("30")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "UNMINT_LBR":
                        //UNMINT_LBR
                        print("31")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "UPDATE_EXCHANGE_RATE":
                        //UPDATE_EXCHANGE_RATE
                        print("32")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "UPDATE_LIBRA_VERSION":
                        //UPDATE_LIBRA_VERSION
                        print("33")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "UPDATE_MINTING_ABILITY":
                        //UPDATE_MINTING_ABILITY
                        print("34")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "CHANGE_SET":
                        //CHANGE_SET
                        print("97")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "BLOCK_METADATA":
                        //BLOCK_METADATA
                        print("98")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    case "UNKNOWN":
                        //UNKNOWN
                        print("100")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    default:
                        print("others")
                        transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_unknow_success_title")
                    }
                }
                transactionStateImageView.image = UIImage.init(named: "transaction_detail_finish")
            } else {
                transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_transaction_failed_title")
                transactionStateLabel.textColor = UIColor.init(hex: "F55753")
                transactionStateImageView.image = UIImage.init(named: "transaction_detail_failed")
            }
        }
    }
    
    var btcTransaction: TrezorBTCTransactionDataModel? {
        didSet {
            guard let model = btcTransaction else {
                return
            }
            transactionDateLabel.text = timestampToDateString(timestamp: model.blockTime ?? 0, dateFormat: "yyyy-MM-dd HH:mm:ss")
            if (model.confirmations ?? 0) >= 6 {
                if model.transaction_type == 0 {
                    // 转账
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_transfer_success_title")
                } else {
                    // 收款
                    transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_receive_success_title")
                }
                transactionStateImageView.image = UIImage.init(named: "transaction_detail_finish")
            } else {
                transactionStateLabel.textColor = UIColor.init(hex: "FAA030")
                transactionStateLabel.text = localLanguage(keyString: "wallet_transaction_detail_uncheck_title")
                transactionStateImageView.image = UIImage.init(named: "transaction_detail_uncheck")
            }
        }
    }
    
//    var messageTransaction: MessageTransactionDetailDataModel? {
//
//    }
    
}

// Errors that can arise at runtime
// Runtime Errors: 4000-4999
//UNKNOWN_RUNTIME_STATUS = 4000,
//EXECUTED = 4001,
//OUT_OF_GAS = 4002,
//// We tried to access a resource that does not exist under the account.
//RESOURCE_DOES_NOT_EXIST = 4003,
//// We tried to create a resource under an account where that resource
//// already exists.
//RESOURCE_ALREADY_EXISTS = 4004,
//// We accessed an account that is evicted.
//EVICTED_ACCOUNT_ACCESS = 4005,
//// We tried to create an account at an address where an account already exists.
//ACCOUNT_ADDRESS_ALREADY_EXISTS = 4006,
//TYPE_ERROR = 4007,
//MISSING_DATA = 4008,
//DATA_FORMAT_ERROR = 4009,
//INVALID_DATA = 4010,
//REMOTE_DATA_ERROR = 4011,
//CANNOT_WRITE_EXISTING_RESOURCE = 4012,
//VALUE_SERIALIZATION_ERROR = 4013,
//VALUE_DESERIALIZATION_ERROR = 4014,
//// The sender is trying to publish a module named `M`, but the sender's account already
//// contains a module with this name.
//DUPLICATE_MODULE_NAME = 4015,
//ABORTED = 4016,
//ARITHMETIC_ERROR = 4017,
//DYNAMIC_REFERENCE_ERROR = 4018,
//CODE_DESERIALIZATION_ERROR = 4019,
//EXECUTION_STACK_OVERFLOW = 4020,
//CALL_STACK_OVERFLOW = 4021,
//NATIVE_FUNCTION_ERROR = 4022,
//GAS_SCHEDULE_ERROR = 4023,
