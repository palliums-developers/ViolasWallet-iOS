//
//  LoanListModel.swift
//  LibraWallet
//
//  Created by wangyingdong on 2020/8/24.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit
import Moya

class LoanListModel: NSObject {
    private var requests: [Cancellable] = []
    @objc var dataDic: NSMutableDictionary = [:]
    deinit {
        requests.forEach { cancellable in
            cancellable.cancel()
        }
        requests.removeAll()
        print("LoanListModel销毁了")
    }
}
