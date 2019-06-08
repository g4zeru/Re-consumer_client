//
//  BarcodeReadeViewController.swift
//  shareB
//
//  Created by iniad on 2019/05/23.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol BarcodeReadViewControllerDelegate: class {
    func dismiss(ean13code: String)
}

class BarcodeReadViewController: BaseViewController {
    let type: [AVMetadataObject.ObjectType] = [.ean13]
    
    private var ean13Code: String = "" {
        didSet {
            if self.ean13Code.isEmpty {
                return
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    private lazy var session = AVCaptureSession()
    private lazy var device: AVCaptureDevice = AVCaptureDevice.default(for: .video)!
    private var input: AVCaptureDeviceInput?
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
    weak var delegate: BarcodeReadViewControllerDelegate?
    
    private var output: AVCaptureMetadataOutput?
    
    private let preview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(displayP3Red: 255/255, green: 254/255, blue: 243/255, alpha: 0.6)
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "バーコードを中心に写してください"
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    override func viewDidLoad() {
        self.view.addSubview(self.preview)
        self.preview.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        self.preview.addSubview(self.label)
        self.label.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview().multipliedBy(0.5)
            maker.centerX.equalToSuperview()
            maker.leading.equalToSuperview().offset(50)
            maker.height.greaterThanOrEqualTo(30)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if targetEnvironment(simulator)
        print("simulator doesn't start camera session")
        #else
        self.cameraAuth()
        #endif
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.session.stopRunning()
        self.delegate?.dismiss(ean13code: self.ean13Code)
        super.viewDidDisappear(animated)
    }
    
    private func cameraAuth() {
        AVCaptureDevice.requestAccess(for: .video) { (bool) in
            if bool {
                self.requestSession()
            }
        }
    }
    
    private func requestSession() {
        DispatchQueue.main.async {
            if self.isRequestSession() {
                self.previewLayer.videoGravity = .resizeAspectFill
                self.previewLayer.frame = self.preview.frame
                self.preview.layer.insertSublayer(self.previewLayer, at: 0)
                self.session.startRunning()
            }
        }
    }
    
    private func isRequestSession() -> Bool {
        do {
            self.input = try AVCaptureDeviceInput.init(device: self.device)
            self.session.addInput(self.input!)
            self.output = AVCaptureMetadataOutput()
            self.session.addOutput(self.output!)
            
            self.output?.metadataObjectTypes = [.ean13]
            self.output?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            self.output?.rectOfInterest = CGRect(x: 0.25, y: 0, width: 0.5, height: 1)
            
            return true
        } catch {
            print(error)
            return false
        }
        
    }
    
    private func extractEan13(metadataObject: AVMetadataObject) -> String? {
        if let object = metadataObject as? AVMetadataMachineReadableCodeObject {
            return object.stringValue
        }
        return nil
    }
}

extension BarcodeReadViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if !metadataObjects.isEmpty {
            self.ean13Code = self.extractEan13(metadataObject: metadataObjects[0]) ?? ""
        }
    }
}
