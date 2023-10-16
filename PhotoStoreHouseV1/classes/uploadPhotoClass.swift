//
//  uploadPhotoClass.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 10/15/23.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

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
    
    func uploadPhotos(){
        if !imageArray.isEmpty{
            
            for imageItem in imageArray {
                // turn image to data
                let imageData = imageItem.jpegData(compressionQuality: 0.9)
                // check that we are able to convert it to data
                guard imageData != nil else {
                    return
                }
                // specify file path and name
                let path = "images/\(UUID().uuidString).jpg"
                let fileRef = storageReference.child(path)
                
                // upload data to firestorage
                let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
                    
                    if error == nil && metadata != nil {
                       // self.isSuccessfulUpload = true
                        self.storeRef.collection("images").document().setData(["url":path]){
                            error in
                            
                            //TODO: If there were no errors, do something
                            if error == nil{
                                print("Saved reference to firestore db successfully")
                            }
                        }
                        
                    }
                }
            }
        }
    }

    
}
