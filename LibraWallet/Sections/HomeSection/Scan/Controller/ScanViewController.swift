//
//  ScanViewController.swift
//  HKWallet
//
//  Created by palliums on 2019/7/23.
//  Copyright © 2019 palliums. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
class ScanViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置背景色为黑色
        self.view.backgroundColor = UIColor.black
        // 加载子View
        self.view.addSubview(detailView)
        // 延时启动相机
        perform(#selector(ScanViewController.startScan), with: nil, afterDelay: 0.3)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        detailView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    override open func viewWillDisappear(_ animated: Bool) {
        // 取消延迟启动
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        // 停止扫描动画
        detailView.stopScan()
        // 停止扫描解析
        scanManager.stop()
    }
    @objc open func startScan() {
        // 开始扫描动画
        detailView.scanView.startScanAnimation()
        // 相机运行
        scanManager.start()
    }
    open func handleCodeResult(arrayResult:[LBXScanResult]) {
        guard arrayResult.isEmpty == false else {
            return
        }
        let result = arrayResult.first
        guard let address = result?.strScanned else {
            //没有获取到
            //开始扫描动画
            detailView.startScan()
            return
        }
        guard address.isEmpty == false else {
            //识别异常
            //开始扫描动画
            detailView.startScan()
            return
        }
        if let action = self.actionClosure {
            action(address)
            self.navigationController?.popViewController(animated: true)
        }
    }
    open func openPhotoAlbum() {
        LBXPermissions.authorizePhotoWith { [weak self] (granted) in
            
            let picker = UIImagePickerController()
            
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            picker.delegate = self;
            
            picker.allowsEditing = true
            
            self?.present(picker, animated: true, completion: nil)
        }
    }
    //是否需要识别后的当前图像
    public  var isNeedCodeImage = false
    typealias successClosure = (String) -> Void
    var actionClosure: successClosure?
    private lazy var detailView : ScanView = {
        let view = ScanView.init()
        return view
    }()
    private lazy var scanManager: LBXScanWrapper = {
        let cropRect = CGRect.zero
        //指定识别几种码
        let arrayCodeType = [AVMetadataObject.ObjectType.qr as NSString,
                             AVMetadataObject.ObjectType.ean13 as NSString,
                             AVMetadataObject.ObjectType.code128 as NSString] as [AVMetadataObject.ObjectType]
        
        let scan = LBXScanWrapper(videoPreView: self.view,objType:arrayCodeType, isCaptureImg: isNeedCodeImage,cropRect:cropRect, success: { [weak self] (arrayResult) -> Void in
            
            if let strongSelf = self {
                // 停止扫描动画
                strongSelf.detailView.stopScan()
                // 解析
                strongSelf.handleCodeResult(arrayResult: arrayResult)
            }
        })
        return scan
    }()
    @objc func rechargeHistory() {
        openPhotoAlbum()
    }
    deinit {
        print("ScanViewController销毁了")
    }
    var myContext = 0
}

extension ScanViewController: UIImagePickerControllerDelegate {
    //MARK: -----相册选择图片识别二维码 （条形码没有找到系统方法）
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let editedImage = info[.editedImage] as? UIImage {
            let arrayResult = LBXScanWrapper.recognizeQRImage(image: editedImage)
            if arrayResult.count > 0 {
                handleCodeResult(arrayResult: arrayResult)
                return
            }
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            let arrayResult = LBXScanWrapper.recognizeQRImage(image: originalImage)
            if arrayResult.count > 0 {
                handleCodeResult(arrayResult: arrayResult)
                return
            }
        }
    }
}
extension ScanViewController: UINavigationControllerDelegate {
    
}