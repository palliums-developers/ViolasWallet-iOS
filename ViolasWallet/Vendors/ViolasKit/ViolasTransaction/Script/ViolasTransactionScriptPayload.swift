//
//  ViolasTransactionScriptPayload.swift
//  ViolasWallet
//
//  Created by palliums on 2019/12/13.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit

struct ViolasTransactionScriptPayload {
    fileprivate let code: Data
    
    fileprivate let typeTags: [ViolasTypeTag]
    
    fileprivate let typeTagsString: [String]
        
    fileprivate let argruments: [ViolasTransactionArgument]
    
    init(code: Data, typeTags: [ViolasTypeTag], argruments: [ViolasTransactionArgument]) {
        
        self.code = code
        
        self.typeTags = typeTags
        
        self.typeTagsString = [String]()
        
        self.argruments = argruments
        
    }
    init(code: Data, typeTagsString: [String], argruments: [ViolasTransactionArgument]) {
        
        self.code = code
        
        self.typeTags = [ViolasTypeTag]()
        
        self.typeTagsString = typeTagsString
        
        self.argruments = argruments
        
    }
    func serialize() -> Data {
        var result = Data()
        // 追加code长度
        result += ViolasUtils.uleb128Format(length: self.code.bytes.count)
        // 追加code数据
        result += self.code

        if typeTags.count > 0 {
            // 追加TypeTag长度
            result += ViolasUtils.uleb128Format(length: typeTags.count)
            // 追加argument数组数据
            for typeTag in typeTags {
                result += typeTag.serialize()
            }
        } else {
            // 追加TypeTag长度
            result += ViolasUtils.uleb128Format(length: typeTagsString.count)
            // 追加argument数组数据
            for typeTag in typeTagsString {
                result += Data.init(Array<UInt8>(hex: typeTag))
            }
        }

        // 追加argument数量
        result += ViolasUtils.uleb128Format(length: argruments.count)
        // 追加argument数组数据
        for argument in argruments {
            result += argument.serialize()
        }
        return result
    }
}
