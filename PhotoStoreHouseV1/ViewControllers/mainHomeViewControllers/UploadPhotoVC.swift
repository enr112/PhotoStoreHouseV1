//
//  UploadPhotoVC.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 10/7/23.
//

import UIKit
import PhotosUI
import FirebaseStorage
import FirebaseFirestore
import ImageIO

class UploadPhotoVC: UIViewController {

    @IBOutlet weak var choosePhotoButton: UIButton!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var tapPhotoLabel: UILabel!
   // @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var upLoadButton: UIBarButtonItem!
    
    var photoLocation: String?
    var photoDetail: String?
    
    // retrieved images
    var imageArray = [UIImage]()
    
    // metadatArray
    var metadatArray = [CFDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        upLoadButton.isHidden = true
        setUpElements()
        tapPhotoLabel.isHidden = true
        tapPhotoLabel.text = "Tap on a photo(s) to add a description."
        tapPhotoLabel.textColor = .systemBlue
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        // get device model
        let device = UIDevice.current.model
        
        var numOfColumns = 3
        if device == "iPad"{
            numOfColumns = 4
        }
        let width = (self.view.frame.size.width - CGFloat((numOfColumns-1) * 10)) / CGFloat(numOfColumns)
        let layout = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: width, height: width)
        updateUI()
    }
    func setUpElements(){
        Utilities.styleHollowButton(choosePhotoButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let index = imageCollectionView.indexPathsForSelectedItems?.first else {
            return
        }
        
        let selectedImage = imageArray[index.item]
        
        if segue.identifier == Constants.Storyboard.photoDesptionVC {
            guard let destinationVC = segue.destination as? PhotoDescriptionVC else {
                return
            }
            destinationVC.recievedData = selectedImage
            destinationVC.descriptionHandler = { (text:String?) -> Void in
                self.photoDetail = text
                destinationVC.locationHandler = { text in
                    self.photoLocation = text
                    
                }
            }
        }
    }

    @IBAction func presentPicker(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0 // multi-selection support
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
        
        //updateUI()
        
    }
    func collectionIsEmpty() ->Bool{
        return imageCollectionView.numberOfItems(inSection: 0) == 0
        // return imageCollectionView.accessibilityTraits.isEmpty
    }
    func updateUI(){
        if collectionIsEmpty(){
            tapPhotoLabel.isHidden = true
            upLoadButton.isHidden = true
        }
        else {
            tapPhotoLabel.isHidden = false
            upLoadButton.isHidden = false
        }
    }
    //---------------------------------------------------------------
    //MARK: -upload
    
    @IBAction func uploadPhotoButton(_ sender: UIBarButtonItem) {
        printDescLoc()
        // create storage reference
        let storageReference = Storage.storage().reference()
        // save a reference of the image file into firestore database
        let db = Firestore.firestore()
        
        let uploadPhotos = UploadPhotos(images: imageArray, storageRef: storageReference, storeDB: db)
        
        uploadPhotos.uploadPhotos()
        
    }
    
    // *********************************************************
    // detect device orientation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if fromInterfaceOrientation == .portrait || fromInterfaceOrientation == .portraitUpsideDown{
            print("Only landscape")
        }
        else{
            print("Only Portrate")
        }
    }
    
}
extension UploadPhotoVC: PHPickerViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        for result in results {
            //updateUI()
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    // cast image to UIImage and append the image to imageArray
                    if let image = image as? UIImage {
                        self.imageArray.append(image)
                    }
                    DispatchQueue.main.async {
                        self.imageCollectionView.reloadData()
                        self.updateUI()
                    }
                }
                // updateUI()
            }
            // retrieve image metadata
            if (result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier)){
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                    if let url = url {
                        let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
                        let data = NSData(contentsOf: url)
                        let imgSrc = CGImageSourceCreateWithData(data ?? NSData(), options as CFDictionary)
                        let metadata = CGImageSourceCopyPropertiesAtIndex(imgSrc!, 0, options as CFDictionary)
                        //var myKey = "DateTime"
                        // CFDictionaryGetValue(metadata, &myKey)
                        // print(CFDictionaryGetValue(metadata, &myKey) ?? "Unknown")
                        self.metadatArray.append(metadata!)
                    }
                }
            }
        }
        // end of loop
    }
}

extension UploadPhotoVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Storyboard.uploadCell, for: indexPath) as? UploadCell else {
            return UICollectionViewCell()
        }
        cell.displayImage.image = imageArray[indexPath.item]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seletedData = imageArray[indexPath.item]
        self.performSegue(withIdentifier: Constants.Storyboard.photoDesptionVC, sender: seletedData)
    }
    func printDescLoc(){
        if let decription = photoDetail {
            debugPrint(decription)
        }
        if let location = photoLocation{
            debugPrint(location)
        }
        
    }
}
