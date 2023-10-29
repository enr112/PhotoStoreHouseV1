//
//  TakePhotoVC.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 10/7/23.
//

import UIKit
import AVFoundation

class TakePhotoVC: UIViewController {
    var imageArray = [UIImage]()
    // Capture Session
    var session:AVCaptureSession?
    // Photo Output
    let output = AVCapturePhotoOutput()
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    // Sutter Button
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let boldSearch = UIImage(systemName: "camera.fill", withConfiguration: boldConfig)
        button.setImage(boldSearch, for: .normal)
        
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 8
        button.layer.borderColor = UIColor.blue.cgColor
        
        return button
    }()
    // exit button
    private let exitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        
        // let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        // let boldSearch = UIImage(systemName: "xmark", withConfiguration: boldConfig)
        // button.setImage(boldSearch, for: .normal)
        button.setTitle("Done", for: .normal)
        
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 8
        button.layer.borderColor = UIColor.blue.cgColor
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        view.addSubview(exitButton)
        
        checkCamaraPermissions()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        
        shutterButton.center = CGPointMake(view.frame.size.width/2-50, view.frame.size.height - 100)
        exitButton.center = CGPointMake(view.frame.size.width/2 + 50, view.frame.size.height - 100)
        
    }

    private func checkCamaraPermissions(){
        
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .notDetermined:
            // request
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamara()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamara()
        @unknown default:
            break
        }
        
    }
    // https://www.youtube.com/watch?v=ZYPNXLABf3c
    
    private func setUpCamara(){
        
        let session = AVCaptureSession()
        
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                //***************************************
                if session.canAddOutput(output){
                    session.addOutput(output)
                }
                //********************************************
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                // session.startRunning()
                DispatchQueue.global(qos: .background).async {
                    session.startRunning()
                }
                self.session = session
            }
            catch {
                print("somtehing happen \(error)")
                
            }
        }
        
    }
    @objc private func didTapTakePhoto(){
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    @objc private func didTapExitButton(){
        if ((session?.isRunning) != nil){
            session?.stopRunning()
        }
        if imageArray.isEmpty {
            popViewVC(animation: true)
        }
        else {
            let toUploadPhotoVC = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.toUploadPhotoVC) as! UploadPhotoVC
            toUploadPhotoVC.imageArray = imageArray
            popViewVC(animation:true)
            
            navigationController?.pushViewController(toUploadPhotoVC, animated: true)
        }
        
    }
    private func popViewVC(animation:Bool){
        if let navController = self.navigationController{
            navController.popViewController(animated: animation)
        }
    }
    func videoOrientation(for deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        switch deviceOrientation {
        case UIDeviceOrientation.portrait:
            return AVCaptureVideoOrientation.portrait
        case UIDeviceOrientation.landscapeLeft:
            return AVCaptureVideoOrientation.landscapeRight
        case UIDeviceOrientation.landscapeRight:
            return AVCaptureVideoOrientation.landscapeLeft
        case UIDeviceOrientation.portraitUpsideDown:
            return AVCaptureVideoOrientation.portraitUpsideDown
        default:
            return AVCaptureVideoOrientation.portrait
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // Update the orientation of the preview layer when the device rotates
        if let connection = previewLayer.connection {
            let newOrientation: AVCaptureVideoOrientation
            switch videoOrientation(for: deviceOrientation()){
            //switch UIDevice.current.orientation {
            case .portrait:
                newOrientation = .portrait
            case .portraitUpsideDown:
                newOrientation = .portraitUpsideDown
            case .landscapeLeft:
                newOrientation = .landscapeLeft//.landscapeRight
            case .landscapeRight:
                newOrientation = .landscapeRight//.landscapeLeft
            default:
                newOrientation = .portrait
            }

            connection.videoOrientation = newOrientation

            coordinator.animate(alongsideTransition: { _ in
                // Apply a transformation to the preview layer to match the new orientation
               // if let previewLayer = self.previewLayer {
                self.previewLayer.connection?.videoOrientation = newOrientation
                self.previewLayer.frame = CGRect(origin: CGPoint.zero, size: size)
               // }
            }, completion: nil)
            super.viewWillTransition(to: size, with: coordinator)
        }
    }
   //-------------------
    @objc func deviceOrientationDidChange(notification:Notification){
        guard let userInfo = notification.userInfo, let customVar = userInfo["customVariable"] as? String else {
            debugPrint("failed to recieve notification as no userInfoExists")
            return
        }
        debugPrint("Recieved update with custom notification variable: \(customVar)")
    }
}
extension TakePhotoVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        
        // session?.stopRunning()
        
        if let image = UIImage(data: data) {
            imageArray.append(image)
        }
        
        /*
        let image = UIImage(data: data)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
         */
 
    }
    
}
