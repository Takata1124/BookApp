//
//  BarcodeViewController.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/20.
//

import UIKit
import AVFoundation

class BarcodeViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    @IBOutlet weak var cameraAreaView: UIView!
    
    let x: CGFloat = 0.1
    let y: CGFloat = 0.4
    let width: CGFloat = 0.8
    let height: CGFloat = 0.2

    let detectionArea = UIView()
    
    var barcodeViewModel: BarcodeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barcodeViewModel = model as? BarcodeViewModel
        setupCaptureSetting()
    }
    
    override func viewDidLayoutSubviews() {
        detectionArea.frame = CGRect(x: view.frame.size.width * x, y: view.frame.size.height * y, width: view.frame.size.width * width, height: view.frame.size.height * height)
        detectionArea.layer.borderColor = UIColor.red.cgColor
        detectionArea.layer.borderWidth = 3
        view.addSubview(detectionArea)
    }
    
    private func setupCaptureSetting() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13]
            metadataOutput.rectOfInterest = CGRect(x: y, y: 1 - x - width, width: height, height: width)
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraAreaView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraAreaView.layer.addSublayer(previewLayer)
 
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    func failed() {
        let alertController = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first else { return}
        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
        guard let stringValue = readableObject.stringValue else { return }

        if !stringValue.isNumber(digit: stringValue.count) {
            return
        }
 
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        captureSession.stopRunning()
        found(code: stringValue)
    }
    
    func found(code: String) {
        Task {
            do {
                if let item = try await barcodeViewModel?.getIsbnBook(isbn: code) {
                    let bookDetailViewModel: BookDetailViewModel = BookDetailViewModel(item: item)
                    Router(viewController: self, nameVC: "BookDetailView", model: bookDetailViewModel).goNextView()
                }
            }
        }
    }

    @IBAction func goBackView(_ sender: Any) {
        Router(viewController: self, nameVC: nil, model: nil).goBackView()
    }
}
