//
//  DepositTableViewManager.swift
//  ViolasWallet
//
//  Created by wangyingdong on 2020/8/26.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit
protocol DepositTableViewManagerDelegate: NSObjectProtocol {
    func headerDelegate(header: DepositTableViewHeaderView)
    func questionHeaderDelegate(header: DepositQuestionTableViewHeaderView)
    func describeHeaderDelegate(header: DepositDescribeTableViewHeaderView)
    //    func tableViewDidSelectRowAtIndexPath(indexPath: IndexPath)
}
class DepositTableViewManager: NSObject {
    weak var delegate: DepositTableViewManagerDelegate?
    var model: DepositItemDetailMainDataModel?
    var dataModels: [DepositLocalDataModel]?
    var showIntroduce: Bool?
    var showQuestion: Bool?
    deinit {
        print("DepositTableViewManager销毁了")
    }
}
extension DepositTableViewManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let tempModels = dataModels, tempModels.isEmpty == false {
                if tempModels[indexPath.row].titleDescribe.isEmpty == false {
                    return 70
                } else {
                    return 48
                }
            } else {
                return 48
            }            
        } else if indexPath.section == 1 {
            if showIntroduce == true {
                if let height = model?.intor?[indexPath.row].height, height > 0 {
                    return 10 + height + 10
                } else {
                    let titleHeight = libraWalletTool.ga_heightForComment(content: model?.intor?[indexPath.row].title ?? "", fontSize: 12, width: mainWidth - 56)
                    let contentHeight = libraWalletTool.ga_heightForComment(content: model?.intor?[indexPath.row].text ?? "", fontSize: 12, width: mainWidth - 56)
                    model?.intor?[indexPath.row].height = titleHeight + 10 + contentHeight
                    return 10 + titleHeight + 10 + contentHeight + 10
                }
            } else {
                return 48
            }
        } else {
            if showQuestion == true {
                if let height = model?.question?[indexPath.row].height, height > 0 {
                    return 10 + height + 10
                } else {
                    let titleHeight = libraWalletTool.ga_heightForComment(content: model?.question?[indexPath.row].title ?? "", fontSize: 12, width: mainWidth - 56)
                    let contentHeight = libraWalletTool.ga_heightForComment(content: model?.question?[indexPath.row].text ?? "", fontSize: 12, width: mainWidth - 56)
                    model?.question?[indexPath.row].height = titleHeight + 10 + contentHeight
                    return 10 + titleHeight + 10 + contentHeight + 10
                }
            } else {
                return 48
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard indexPath.section != 0 else {
            return
        }
        //        self.delegate?.tableViewDidSelectRowAtIndexPath(indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 162
        } else if section == 1{
            return 48
        } else if section == 2 {
            return 48
        } else {
            return 0.001
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let identifier = "Header"
            if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? DepositTableViewHeaderView {
                header.productModel = self.model
                self.delegate?.headerDelegate(header: header)
                return header
            } else {
                let header = DepositTableViewHeaderView.init(reuseIdentifier: identifier)
                header.productModel = self.model
                self.delegate?.headerDelegate(header: header)
                return header
            }
        } else if section == 1 {
            let identifier = "DescribeHeader"
            if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? DepositDescribeTableViewHeaderView {
                self.delegate?.describeHeaderDelegate(header: header)
                header.showIntroduce = showIntroduce
                return header
            } else {
                let header = DepositDescribeTableViewHeaderView.init(reuseIdentifier: identifier)
                self.delegate?.describeHeaderDelegate(header: header)
                header.showIntroduce = showIntroduce
                return header
            }
        } else if section == 2 {
            let identifier = "DepositHeader"
            if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? DepositQuestionTableViewHeaderView {
                self.delegate?.questionHeaderDelegate(header: header)
                header.showQuestions = showQuestion
                return header
            } else {
                let header = DepositQuestionTableViewHeaderView.init(reuseIdentifier: identifier)
                self.delegate?.questionHeaderDelegate(header: header)
                header.showQuestions = showQuestion
                return header
            }
        } else {
            let view = UIView.init()
            view.backgroundColor = UIColor.init(hex: "F7F7F9")
            return view
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = UIColor.init(hex: "F7F7F9")
        return view
    }
}
extension DepositTableViewManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataModels?.count ?? 0
        } else if section == 1 {
            if showIntroduce == true {
                return model?.intor?.count ?? 0
            } else {
                return 0
            }
        } else {
            if showQuestion == true {
                return model?.question?.count ?? 0
            } else {
                return 0
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let identifier = "NormalCell"
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? DepositTableViewCell {
                if let data = dataModels, data.isEmpty == false {
                    cell.model = data[indexPath.row]
                    cell.hideSpcaeLineState = (data.count - 1) == indexPath.row ? true:false
                }
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = DepositTableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
                if let data = dataModels, data.isEmpty == false {
                    cell.model = data[indexPath.row]
                    cell.hideSpcaeLineState = (data.count - 1) == indexPath.row ? true:false
                }
                cell.selectionStyle = .none
                return cell
            }
        } else if indexPath.section == 1 {
            let identifier = "DescribeCell"
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? DepositDescribeTableViewCell {
                if let data = model?.intor, data.isEmpty == false {
                    cell.model = data[indexPath.row]
                }
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = DepositDescribeTableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
                if let data = model?.intor, data.isEmpty == false {
                    cell.model = data[indexPath.row]
                }
                cell.selectionStyle = .none
                return cell
            }
        } else {
            let identifier = "QuestionCell"
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? DepositQuestionTableViewCell {
                if let data = model?.question, data.isEmpty == false {
                    cell.model = data[indexPath.row]
                }
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = DepositQuestionTableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
                if let data = model?.question, data.isEmpty == false {
                    cell.model = data[indexPath.row]
                }
                cell.selectionStyle = .none
                return cell
            }
        }
        //
    }
}
