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
import DropDown

class UploadPhotoVC: UIViewController {

    @IBOutlet weak var choosePhotoButton: UIButton!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var tapPhotoLabel: UILabel!
   // @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var upLoadButton: UIBarButtonItem!
    
    // retrieved images
    var imageArray = [UIImage]()
    // array of descriptions
    var descriptions = [Int:String?]()
    
    // array of locations
    var locations = [Int:String?]()
    
    // array of available folders
    // var foldersAvailable = [String]()
    var foldersAvailable = [String]()
    
    // metadatArray
    var metadatArray = [CFDictionary]()
    
    // folder menu
    var folderList = DropDown()
    
    var circularProgressBar: CircularProgressBar!
   
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
        getFolderNames()
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
                self.descriptions[index.item] = text
                destinationVC.locationHandler = { text in
                    self.locations[index.item] = text
                    
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
        createFolderList(sender) { selectedFolderName in
            if let selectedFolderName = selectedFolderName {
                
                // Initialize the circular progress bar
                self.circularProgressBar = CircularProgressBar(frame: CGRect(x: 200, y: 200, width: 200, height: 200))
                self.circularProgressBar.tag = 100
                self.circularProgressBar.center = self.view.center
                self.view.addSubview(self.circularProgressBar)
                
                // create storage reference
                let storageReference = Storage.storage().reference()
                // save a reference of the image file into firestore database
                let db = Firestore.firestore()
                
                let uploadPhotos = UploadPhotos(images: self.imageArray, storageRef: storageReference, storeDB: db)
                uploadPhotos.uploadPhotos(description: self.descriptions, location: self.locations, folderName: selectedFolderName, timeStamp: self.timeStamp(), progressBar: self.circularProgressBar) {
                    
                    // Completion handler - dismiss the progress bar
                    DispatchQueue.main.async {
                        if let progressBar = self.view.viewWithTag(100) as? CircularProgressBar {
                            progressBar.removeFromSuperview()
                            self.upLoadButton.title = "Upload Completed"
                            self.upLoadButton.isEnabled = false
                        }
                    }
                    
                }
            }
            else {
                return
            }
        }

        
       /*
        // create storage reference
        let storageReference = Storage.storage().reference()
        // save a reference of the image file into firestore database
        let db = Firestore.firestore()
        
        let uploadPhotos = UploadPhotos(images: imageArray, storageRef: storageReference, storeDB: db)
        
        uploadPhotos.uploadPhotos(description: descriptions, location: locations, timeStamp: timeStamp())
        */
        
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
    func timeStamp() -> String{
        //--------------------------------------
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy hh:mm a"
        let result = formatter.string(from: date)
        //--------------------------------------------
        return result
    }
    
    // get the list of folders available
    func getFolderNames(){
        RetrieveFolders.retrieveFolderNames { folderNames in
            if let folderNames = folderNames {
                // Use the retrieved folder names here
                self.foldersAvailable = folderNames
                
            } else {
                // Handle the error
                print("Failed to retrieve folders")
                self.upLoadButton.title = "Cannot retrieve folders"
            }
        }
    }
    /*
    func createFolderList(_ sender: UIBarButtonItem) -> String?{
        
        var folderName:String?
        // create a list of available folders
        folderList.dataSource = foldersAvailable
        folderList.anchorView = sender
        //folderList.bottomOffset = CGPoint(x: 0, y: sender.size.height)
            folderList.show()
        
        folderList.selectionAction = {index, title in
            sender.title = "Uploaded to \(title)"
            folderName = title
            print("index \(index) and \(title)")
            
        }
        return folderName
    }
     */
    func createFolderList(_ sender: UIBarButtonItem, completion: @escaping (String?) -> Void) {
        var folderName: String?
        // create a list of available folders
        folderList.dataSource = foldersAvailable
        folderList.anchorView = sender
        
        folderList.cellNib = UINib(nibName: "DropDownCell", bundle: nil)
        folderList.customCellConfiguration = { index, title, cell in
            
            guard let cell = cell as? FolderDropDownCell else {
                return
            }
            cell.folderIcon.image = UIImage(systemName: "folder.fill")

        }
        
        // folderList.bottomOffset = CGPoint(x: 0, y: sender.size.height)
        folderList.show()
        
        folderList.selectionAction = { index, title in
            sender.title = "Uploaded to \(title)"
            folderName = title
            print("index \(index) and \(title)")
            completion(folderName) // Call the completion handler with the selected folderName
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
}
