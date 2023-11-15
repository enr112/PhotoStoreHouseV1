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
    var belonsToFolder:String
    var url:String
    
    init(name:String, description:String, location:String, timeStamp:String, associatedUser:String, belonsToFolder:String, url:String){
        self.name = name
        self.description = description
        self.location = location
        self.timeStamp = timeStamp
        self.associatedUser = associatedUser
        self.belonsToFolder = belonsToFolder
        self.url = url
    }
}
