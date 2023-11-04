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
    var timeStamp:Date
    var associatedUser:String
    //var photoID:String
    var url:String
    
    init(name:String, description:String, location:String, timeStamp:Date, associatedUser:String, url:String){
        self.name = name
        self.description = description
        self.location = location
        self.timeStamp = timeStamp
        self.associatedUser = associatedUser
        self.url = url
    }
    func uploadPhotoReference(){
        
    }
}
