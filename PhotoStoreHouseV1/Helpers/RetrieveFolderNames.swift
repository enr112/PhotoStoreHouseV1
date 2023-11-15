//
//  RetrieveFolderNames.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 11/11/23.
//

import UIKit
import FirebaseFirestore

struct FolderNames{
    
    static func retrieveFolderNames(completion: @escaping ([String]?) -> Void) {
            // Get a reference to the Firestore database
            let db = Firestore.firestore()
            
            // Create a query to fetch document names without contents
            let query = db.collection("folders")
            
            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(nil) // Return nil to indicate an error
                } else {
                    var folderNames = [String]()
                    for document in querySnapshot!.documents {
                        // Access the document ID (name)
                        let documentID = document.documentID
                        folderNames.append(documentID)
                       // print("Document ID: \(documentID)")
                    }
                    completion(folderNames) // Return the folder names when the query is complete
                }
            }
        }
    static func retrieveFolderDocument(folderName: String, completion: @escaping ([Photo]?) -> Void){
       let db = Firestore.firestore()
       
        let folderRef = db.collection("folders").document(folderName).collection("photos")
        
        folderRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting folder documents: \(error)")
                completion(nil) // Return nil to indicate an error
            }
            else {
                var photoDocs = [Photo]()
                //*******************************************
                if querySnapshot != nil {
                    
                    for document in querySnapshot!.documents {
                        if document.exists{
                            let data = document.data()
                            
                            if let name = data["name"] as? String,
                               let description = data["description"] as? String,
                               let location = data["location"] as? String,
                               let timeStamp = data["timeStamp"] as? String,
                               let associatedUser = data["associatedUser"] as? String,
                               let url = data["url"] as? String,
                               let belongsToFolder = data["belongsToFolder"] as? String {
                                
                                let photoDocument = Photo(name: name, description: description, location: location, timeStamp: timeStamp, associatedUser: associatedUser, belonsToFolder: belongsToFolder, url: url)
                                photoDocs.append(photoDocument)
                            }
                            else {
                                completion(nil) // Data is incomplete or of wrong type
                                print("Data is incomplete")
                            }
                        } // end of document.exists()
                        else{
                            completion(nil) // Folder document doesn't exist
                            print("Folder document does not exist")
                        }
                    } // end of for loop
                    completion(photoDocs)
                } // end inner if
                else {
                    completion(nil)
                    print("Error getting photo documents")
                }
                //**********************************************
            } // end of else
        } // end folderRef
        
    }
}
