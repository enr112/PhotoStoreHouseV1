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
    
    var imagePicker = UIImagePickerController()


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

//        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
 //       exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        
      }
    
    @IBAction func didTapNewPhoto(_ sender: UIButton) {
        presentImagePicker()
    }
    
    @IBAction func didTapDone(_ sender: UIButton) {
        userFinishedCapturingImages()
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
            // popViewVC(animation:true)
            
            navigationController?.pushViewController(toUploadPhotoVC, animated: true)
        }
    }
}
