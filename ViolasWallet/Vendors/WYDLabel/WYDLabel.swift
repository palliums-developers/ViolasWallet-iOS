//
//  WYDLabel.swift
//  ViolasWallet
//
//  Created by wangyingdong on 2021/1/19.
//  Copyright © 2021 palliums. All rights reserved.
//

import UIKit

class WYDLabel: UILabel {
    // 1.定义一个接受间距的属性
    var textInsets = UIEdgeInsets.zero
    
    //2. 返回 label 重新计算过 text 的 rectangle
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard text != nil else {
            return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        }
        
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    //3. 绘制文本时，对当前 rectangle 添加间距
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}
