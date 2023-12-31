//
//  uploadPhotoClass.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 10/15/23.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadPhotos{
    var isSuccessfulUpload = false
    var imageArray = [UIImage]()
    let storageReference:StorageReference
    let storeRef:Firestore
    
    init(images: [UIImage], storageRef:StorageReference, storeDB:Firestore) {
        self.imageArray = images
        self.storageReference = storageRef
        self.storeRef = storeDB
    }
    
    func uploadPhotos(description:[Int:String?], location:[Int:String?], folderName:String, timeStamp:String, progressBar:CircularProgressBar?, completion: @escaping () -> Void){
        guard !imageArray.isEmpty else {
            // Handle case where imageArray is empty
            completion()
            return
        }
            
            var index = 0
            let dispatchGroup = DispatchGroup()
            
            for imageItem in imageArray {
                dispatchGroup.enter()

                // turn image to data
                let imageData = imageItem.jpegData(compressionQuality: 0.9)
                // check that we are able to convert it to data
                guard imageData != nil else {
                    return
                }
                // photo name
                let name = "\(UUID().uuidString).jpg"
                // specify file path and name
                // let path = "images/\(UUID().uuidString).jpg"
                let path = "images/\(name)"
                let fileRef = storageReference.child(path)
                
                // get current user
                let userID = Auth.auth().currentUser?.uid ?? "Unknown user"
                let desc = self.descriptionArray(desc: description, indexKey: index)
                let loc = self.locationArray(desc: location, indexKey: index)
                
                let dataType = StorageMetadata.init()
                dataType.contentType = "image/jpeg"
                
                // upload data to firestorage
                let uploadTask = fileRef.putData(imageData!, metadata: dataType) { metadata, error in
                    
                    if let error = error{
                        print("An error ocurred --> \(error.localizedDescription)")
                        return
                    }
                    print("Image was succefully uploaded. recieved metadata --> \(String(describing: metadata))")
                    
                    if metadata != nil {
                        
                       // self.storeRef.collection("images").document().setData(["url":path])
                        self.storeRef.collection("folders").document(folderName).collection("photos").document().setData(["name": name, "description":desc, "location":loc, "timeStamp":timeStamp, "associatedUser": userID, "url":path, "belongsToFolder":folderName]){
                            error in
                            
                            //TODO: If there were no errors, do something
                            if error == nil{
                                print("Saved reference to firestore db successfully")
                            }
                            else{
                                print("image was uploaded but reference to image could not be saved in firestore")
                            }
                            dispatchGroup.leave()
                        }
                    }
                    // Increment index inside the completion block
                    //index += 1
                  }
                uploadTask.observe(.progress){ [weak self] (snapshot) in
                    guard let fracCompletedValue = snapshot.progress?.fractionCompleted else {return}
                    print("task is \(fracCompletedValue) complete")
                    // self.progressView.progress = Float(fracCompletedValue)
                    
                    // Update the circular progress bar in the main queue
                    DispatchQueue.main.async {
                        progressBar?.setProgress(Float(fracCompletedValue))
                    }
                }
                index += 1
            } // end of for loop
        
        dispatchGroup.notify(queue: .main) {
            // Call completion handler when all images are uploaded
            completion()
        }
        
    }

    func descriptionArray(desc:[Int:String?], indexKey:Int)->String{
        var value = ""
        if let description = desc[indexKey]{
            value = description ?? "none"
        }
        return value
    }
    func locationArray(desc:[Int:String?], indexKey:Int)->String{
        var value = ""
        if let location = desc[indexKey]{
            value = location ?? "none"
        }
        return value
    }
}
