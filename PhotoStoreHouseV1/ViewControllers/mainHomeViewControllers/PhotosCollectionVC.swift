//
//  PhotosCollectionVC.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 11/7/23.
//

import UIKit
import FirebaseStorage

class PhotosCollectionVC: UIViewController {
    @IBOutlet weak var folderNameLabel: UILabel!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var availablePhotosLabel: UILabel!
    // retrieved photo files from firestore
    var photoFiles = [PhotoDocument]()
    var retrievedImages = [UIImage]()
    var photos = [PhotoAndFile]()
    
    var folderName:String?
    
    var setFolderName: String {
        get {
            folderName ?? "unknown"
        }
        set{
            folderName = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //folderNameLabel.text = setFolderName
        if let folderName = folderName{
            retrieveFolderDocument(folderName: folderName)
        }
        else {
            folderNameLabel.text = "unknown folder"
        }
        self.title = folderName
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        // get device model
        let device = UIDevice.current.model
        
        var numOfColumns = 3
        if device == "iPad"{
            numOfColumns = 5
        }
        let width = (self.view.frame.size.width - CGFloat((numOfColumns-1) * 10)) / CGFloat(numOfColumns)
        let layout = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: width, height: width)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let index = imageCollectionView.indexPathsForSelectedItems?.first else {
            return
        }
        
        let selectedData = photos[index.item]
        
        if segue.identifier == Constants.Storyboard.photoDetailsVC {
            guard let destinationVC = segue.destination as? DetailsVC else {
                return
            }
            destinationVC.imageDocument = selectedData
//            destinationVC.descriptionHandler = { (text:String?) -> Void in
//                self.descriptions[index.item] = text
//                destinationVC.locationHandler = { text in
//                    self.locations[index.item] = text
//
//                }
//            }
        }
    }

}

extension PhotosCollectionVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedData = photos[indexPath.item]
        self.performSegue(withIdentifier: Constants.Storyboard.photoDetailsVC, sender: selectedData)
    }
}
extension PhotosCollectionVC:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        DispatchQueue.main.async {
//            self.imageCollectionView.reloadData()
//        }
        return photos.count//retrievedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:PhotoCell.indentifier , for: indexPath) as? PhotoCell else{
            return UICollectionViewCell()
        }
        //cell.folderIcon.image = UIImage(systemName: "folder.fill")
        let photoDoc = photos[indexPath.item]
        //cell.configureImage(image: photos[indexPath.item].image )
        cell.configureImage(image: photoDoc.image )
        cell.configureDateLabel(dateLabel: photoDoc.photoDocument.timeStamp)
        
        return cell
    }
    
    
}

extension PhotosCollectionVC {
    func retrieveFolderDocument(folderName:String){
        RetrieveFolders.retrieveFolderDocument(folderName: folderName) { folderDocuments in
            if let folderDocuments = folderDocuments {
                if folderDocuments.isEmpty{
                    self.availablePhotosLabel.text = "This folder is empty"
                }
                else{
                    // use retrieved folder douments
                    self.photoFiles = folderDocuments
                    // self.retrievePhotos()
                    self.retrieveImages()
                }

            }
            else {
                print("Could not get photo files or an error occured")
            }
        }
    }
    // retrieve photos using the url retrieved from firestore
    func retrievePhotos(){
        
        // get a reference to storage
        let storageRef = Storage.storage().reference()
        
        let dispatchGroup = DispatchGroup()

        // Create a background task identifier
        var backgroundTask: UIBackgroundTaskIdentifier = .invalid

        backgroundTask = UIApplication.shared.beginBackgroundTask {
            // This block will be called if the task is still running when the app enters the background
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }

        for index in 0..<photoFiles.count {
            let path = photoFiles[index].url
            let imageRef = storageRef.child(path)

            dispatchGroup.enter()

            imageRef.getData(maxSize: 5*1024*1024) { data, error in
                defer {
                    dispatchGroup.leave()
                }

                if error == nil, let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.retrievedImages.append(image)
                    }
                }
            }
        } // end of for loop

        dispatchGroup.notify(queue: .main) {
            self.imageCollectionView.reloadData()

            // End the background task once all tasks are completed
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
        
/*
        // loop throught each photo file to get the url and retrieve the actual image
        for index in 0..<photoFiles.count{
            
            let path = photoFiles[index].url
  
            // specify the path
            let imageRef = storageRef.child(path)
            
            
            //retrieve the data
            imageRef.getData(maxSize: 5*1024*1024) { data, error in
                // check for errors
                if let error = error {
                    print("Error getting image -> \(error)")
                }
                else {
                    if data != nil {
                        if let image = UIImage(data: data!){
                            DispatchQueue.main.async {
                                self.retrievedImages.append(image)
                            }
                        }
                    }
                    else {
                        print("cannot retrieve data -> nil value")
                    }
                }
                
            } // end of completion
        } // end of loop
         */
    }
    
    func retrieveImages(){
        // Get a reference to storage
        let storageRef = Storage.storage().reference()

        // Create a dispatch group
        let dispatchGroup = DispatchGroup()

        for index in 0..<photoFiles.count {
            let path = photoFiles[index].url

            // Enter the dispatch group before starting the asynchronous task
            dispatchGroup.enter()

            retrieveImage(storageRef: storageRef, path: path) { retrievedImage, error in
                defer {
                    // Leave the dispatch group when the task is done
                    dispatchGroup.leave()
                }

                if error == nil, let retrievedImage = retrievedImage {
                    let photoDoc = PhotoAndFile(photoDocument: self.photoFiles[index], image: retrievedImage)
                    self.photos.append(photoDoc)
                }
                else {
                    print("An error occured \(String(describing: error))")
                }
            }
        }

        // Notify when all tasks in the dispatch group are finished
        dispatchGroup.notify(queue: .main) {
            self.imageCollectionView.reloadData()
            print("All images retrieved")
        }
        
    }
    
    // retrieves a single image
    func retrieveImage(storageRef:StorageReference, path:String, completion: @escaping (UIImage?, Error?) -> Void){
          
        let imageRef = storageRef.child(path)
        
        imageRef.getData(maxSize: 5*1024*1024) { data, error in
            
            if error == nil, let data = data, let image = UIImage(data: data){
                completion(image, nil)
            }
            else {
                completion(nil, error)
                print("Cannot download image data or an error ocurred")
            }
        } // end of imageRef
    }
}
