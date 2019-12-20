//
//  TransactionScript.swift
//  LibraWallet
//
//  Created by palliums on 2019/11/14.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit

class TransactionScript: NSObject {
    fileprivate let code: Data
        
    fileprivate let argruments: [TransactionArgument]
        
    fileprivate let programPrefixData: Data = Data.init(hex: "02000000")
    
    init(code: Data, argruments: [TransactionArgument]) {
        
        self.code = code
        
        self.argruments = argruments
        
    }
    func serialize() -> Data {
        var result = Data()
        // 追加类型
        result += programPrefixData
        // 追加code长度
        result += getLengthData(length: self.code.bytes.count, appendBytesCount: 4)
        // 追加code数据
        result += self.code
        // 追加argument数量
        result += getLengthData(length: argruments.count, appendBytesCount: 4)
        // 追加argument数组数据
        for argument in argruments {
            result += argument.serialize()
        }
        return result
    }
}
