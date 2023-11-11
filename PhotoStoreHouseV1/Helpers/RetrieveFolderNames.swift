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
                        print("Document ID: \(documentID)")
                    }
                    completion(folderNames) // Return the folder names when the query is complete
                }
            }
        }
}
