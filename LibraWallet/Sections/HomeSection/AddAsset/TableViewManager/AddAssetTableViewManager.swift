//
//  AddAssetTableViewManager.swift
//  LibraWallet
//
//  Created by palliums on 2019/11/1.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit
protocol AddAssetTableViewManagerDelegate: NSObjectProtocol {
    func switchButtonChange(model: ViolasTokenModel, state: Bool, indexPath: IndexPath)
//    func tableViewDidSelectRowAtIndexPath(indexPath: IndexPath, model: ViolasTokenModel)
}
class AddAssetTableViewManager: NSObject {
    weak var delegate: AddAssetTableViewManagerDelegate?
    var dataModel: [ViolasTokenModel]?
    var headerData: LibraWalletManager?
    deinit {
        print("AddAssetTableViewManager销毁了")
    }
}
extension AddAssetTableViewManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
//        guard let model = self.dataModel else {
//            return
//        }
//        self.delegate?.tableViewDidSelectRowAtIndexPath(indexPath: indexPath, model: model[indexPath.row])
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = "Header"
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) {
            (header as! AddAssetTableViewHeader).model = self.headerData
            return header
        } else {
            let header = AddAssetTableViewHeader.init(reuseIdentifier: identifier)
            header.model = self.headerData
            return header
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}
extension AddAssetTableViewManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "CellNormal"
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AddAssetViewTableViewCell {
            if let data = dataModel, data.isEmpty == false {
                (cell ).model = data[indexPath.row]
            }
            cell.selectionStyle = .none
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        } else {
            let cell = AddAssetViewTableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
            if let data = dataModel, data.isEmpty == false {
                cell.model = data[indexPath.row]
            }
            cell.selectionStyle = .none
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        }
    }
}
extension AddAssetTableViewManager: AddAssetViewTableViewCellDelegate {
    func switchButtonChange(model: ViolasTokenModel, state: Bool, indexPath: IndexPath) {
        self.delegate?.switchButtonChange(model: model, state: state, indexPath: indexPath)
    }
}
