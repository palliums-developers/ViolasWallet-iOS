//
//  YieldFarmingView.swift
//  ViolasWallet
//
//  Created by wangyingdong on 2020/12/4.
//  Copyright © 2020 palliums. All rights reserved.
//

import UIKit
import WebKit
import Localize_Swift

class YieldFarmingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(webView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("YieldFarmingView销毁了")
    }
    //MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.right.bottom.equalTo(self)
        }
    }
    //MARK: - 懒加载对象
    lazy var webView: WKWebView = {
        let webView = WKWebView.init()
        // 下面一行代码意思是充满的意思(一定要加，不然也会显示有问题)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.load(webRequest)
        return webView
    }()
    lazy var webRequest: URLRequest = {
        var request = URLRequest.init(url: URL(string: yieldFarmingURL + "?address=\(Wallet.shared.violasAddress ?? "")&language=\(Localize.currentLanguage())")!)
        request.cachePolicy = .reloadIgnoringCacheData
        return request
    }()
    lazy var toastView: ToastView = {
        let toast = ToastView.init()
        return toast
    }()
}
