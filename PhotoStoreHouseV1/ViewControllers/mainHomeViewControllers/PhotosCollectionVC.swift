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
    
    // retrieved photo files from firestore
    var photoFiles = [Photo]()
    var retrievedImages = [UIImage]()
    
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
            retrieveFolderDocumenst(folderName: folderName)
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PhotosCollectionVC: UICollectionViewDelegate{
    
}
extension PhotosCollectionVC:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        DispatchQueue.main.async {
//            self.imageCollectionView.reloadData()
//        }
        return retrievedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:PhotoCell.indentifier , for: indexPath) as? PhotoCell else{
            return UICollectionViewCell()
        }
        //cell.folderIcon.image = UIImage(systemName: "folder.fill")
        cell.configureImage(image: retrievedImages[indexPath.item] )
        
        return cell
    }
    
    
}

extension PhotosCollectionVC {
    func retrieveFolderDocumenst(folderName:String){
        FolderNames.retrieveFolderDocument(folderName: folderName) { folderDocuments in
            if let folderDocuments = folderDocuments {
                // use retrieved folder douments
                self.photoFiles = folderDocuments
                self.retrievePhotos()
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
        }

        dispatchGroup.notify(queue: .main) {
            self.imageCollectionView.reloadData()

            // End the background task once all tasks are completed
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
        
/*
        // loop thought each photo file to get the url and retrieve the actual image
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
}
