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
    
    func uploadPhotos(description:[Int:String?], location:[Int:String?], timeStamp:String){
        if !imageArray.isEmpty{
            
            var index = 0
            
            for imageItem in imageArray {
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
                
                // upload data to firestorage
                let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
                    
                    if error == nil && metadata != nil {
                        
                       // self.storeRef.collection("images").document().setData(["url":path])
                        self.storeRef.collection("folders").document("boston01").collection("photos").document().setData(["name": name, "description":desc, "location":loc, "timeStamp":timeStamp, "associateUser": userID, "url":path]){
                            error in
                            
                            //TODO: If there were no errors, do something
                            if error == nil{
                                print("Saved reference to firestore db successfully")
                            }
                        }
                    }
                  }
                index += 1
            } // end of for loop
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
