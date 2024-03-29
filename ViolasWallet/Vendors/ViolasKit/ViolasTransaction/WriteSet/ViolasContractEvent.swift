//
//  ViolasContractEvent.swift
//  ViolasWallet
//
//  Created by wangyingdong on 2020/8/28.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit

struct ViolasContractEvent {
    // EventKey（key长度24字节）
    fileprivate let key: String
    //
    fileprivate let sequenceNumber: UInt64
    
    fileprivate let typeTag: ViolasTypeTag
    
    fileprivate let eventData: String
    
    init(key: String, sequenceNumber: UInt64, typeTag: ViolasTypeTag, eventData: String) {
        self.key = key
        
        self.sequenceNumber = sequenceNumber
        
        self.typeTag = typeTag
        
        self.eventData = eventData
    }
    func serialize() -> Data {
        var result = Data()
        // 追加类型
        result += Data.init(Array<UInt8>(hex: key))
        
        result += ViolasUtils.getLengthData(length: sequenceNumber, appendBytesCount: 8)
        
        result += typeTag.serialize()
        
        result += Data.init(Array<UInt8>(hex: eventData))
        
        return result
    }
}
