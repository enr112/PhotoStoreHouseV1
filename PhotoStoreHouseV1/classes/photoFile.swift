//
//  photoFile.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 10/14/23.
//
import FirebaseFirestore

import Foundation
/*
struct Photo{
    var name:String
    var belongsToFolder:String
    var depscription:String
    var location:String
    var timeStamp:Date
    var associatedUser:String
    var photoID:String
}
 */
class Photo {
    var name:String
    //var belongsToFolder:String
    var description:String
    var location:String
    var timeStamp:String
    var associatedUser:String
    //var photoID:String
    var url:String
    
    init(name:String, description:String, location:String, timeStamp:String, associatedUser:String, url:String){
        self.name = name
        self.description = description
        self.location = location
        self.timeStamp = timeStamp
        self.associatedUser = associatedUser
        self.url = url
    }
    func uploadPhotoReference(fireStore:Firestore, photoURL:String){
        fireStore.collection("images").document("boston01").collection("photos").document().setData(["name": name, "description":description, "location":location, "timeStamp":timeStamp, "associateUser": associatedUser, "url":photoURL]
        
        ){
            error in
            
            //TODO: If there were no errors, do something
            if error == nil{
                print("Saved reference to firestore db successfully")
            }
        }
    }
}
