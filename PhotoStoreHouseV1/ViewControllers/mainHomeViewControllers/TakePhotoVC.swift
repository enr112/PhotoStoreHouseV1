//
//  TakePhotoVC.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 10/7/23.
//

import UIKit
import AVFoundation

class TakePhotoVC: UIViewController {
    var capturedImages = [UIImage]()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var newPhotoButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var discardButton: UIButton!
    
    var imagePicker = UIImagePickerController()


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupButtons()
        imageView.frame = CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height * 0.2)
//        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
 //       exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        
      }
    private func setupButtons(){
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        var boldSearch = UIImage(systemName: "camera.fill", withConfiguration: boldConfig)
        newPhotoButton.setImage(boldSearch, for: .normal)
        newPhotoButton.layer.cornerRadius = 40
        newPhotoButton.layer.borderWidth = 4
        newPhotoButton.layer.borderColor = UIColor.blue.cgColor
        //newPhotoButton.titleLabel?.isHidden = true
        
        //newPhotoButton.setImage(boldSearch, for: .normal)
        doneButton.layer.cornerRadius = 40
        doneButton.layer.borderWidth = 4
        doneButton.layer.borderColor = UIColor.blue.cgColor
        
        boldSearch = UIImage(systemName: "trash.fill", withConfiguration: boldConfig)
        discardButton.setImage(boldSearch, for: .normal)
        discardButton.layer.cornerRadius = 40
        discardButton.layer.borderWidth = 4
        discardButton.layer.borderColor = UIColor.blue.cgColor
    
        
//            let shutterButton: UIButton = {
//            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
//
//            let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
//            let boldSearch = UIImage(systemName: "camera.fill", withConfiguration: boldConfig)
//            button.setImage(boldSearch, for: .normal)
//
//            button.layer.cornerRadius = 40
//            button.layer.borderWidth = 8
//            button.layer.borderColor = UIColor.blue.cgColor
//
//            return button
//        }()
    }
    
    @IBAction func didTapNewPhoto(_ sender: UIButton) {
        presentImagePicker()
    }
    
    @IBAction func didTapDone(_ sender: UIButton) {
        userFinishedCapturingImages()
    }
    @IBAction func didTapDiscard(_ sender: UIButton) {
//        guard let currentImage = imageView.image else {
//            return
//        }
//        let lastImage = capturedImages.last
//        guard let removeLastElement = lastImage else {
//            return
//        }
        if imageView.image != nil && capturedImages.last != nil{
            capturedImages.removeLast()
            if capturedImages.last != nil {
                imageView.image = capturedImages.last
            }
            else {
                imageView.image = UIImage()
            }
        }
        return
    }
    
    /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        
        shutterButton.center = CGPointMake(view.frame.size.width/2-50, view.frame.size.height - 100)
        exitButton.center = CGPointMake(view.frame.size.width/2 + 50, view.frame.size.height - 100)
        
    }
*/
    func presentImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            // capturedImages.removeAll() // Clear any previously captured images

            // Present the image picker
            present(imagePicker, animated: true, completion: nil)
        } else {
            // Handle the case where the device doesn't have a camera or camera is not accessible.
            print("Camera not available.")
        }
    }

    // https://www.youtube.com/watch?v=ZYPNXLABf3c
    
 /*
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
  */
    private func popViewVC(animation:Bool){
        if let navController = self.navigationController{
            navController.popViewController(animated: animation)
        }
    }

    
}
extension TakePhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // dismiss picker if user does not choose a photo
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate method to handle the captured image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            capturedImages.append(image)
            imageView.image = image

            // You can display the captured image or provide a way for the user to take more pictures.
            // Optionally, you can add a button in your UI for taking more pictures or finishing.
            // If the user wants to capture more, call presentImagePickerForMultipleImages() again.
            // If the user is finished, you can save or process the capturedImages array.

            // Dismiss the image picker
            picker.dismiss(animated: true, completion: nil)
        }
    }

    // Function to handle when the user is finished capturing images
    func userFinishedCapturingImages() {
        if capturedImages.isEmpty {
            popViewVC(animation: true)
        }
        else {
            let toUploadPhotoVC = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.toUploadPhotoVC) as! UploadPhotoVC
            toUploadPhotoVC.imageArray = capturedImages
            
            capturedImages.removeAll()
            imageView.image = UIImage()
            // popViewVC(animation:true)
            
            
            navigationController?.pushViewController(toUploadPhotoVC, animated: true)
        }
    }
}
