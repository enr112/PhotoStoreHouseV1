//
//  ManageUsers.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 12/4/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

struct ManageUsers {
    
    func getCurrentUser(completion: @escaping (User?, Error?) -> Void){
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            let email = currentUser.email
            let displayName = currentUser.displayName
            
            print("user ID = \(userID)\nuser email --> \(String(describing: email))")
            print("displayName --> \(String(describing: displayName))")
            
            completion(currentUser, nil)
        }
        else {
            // No user is currently logged in
            completion(nil, nil)
            print("No user is currently logged in")
        }
    }
    
    func getUserDocument(completion: @escaping (UserDocument?, Error?) -> Void) {
       
        getCurrentUser { currentUser, error in
            if let error = error {
                print("Error retrieving current user: \(error.localizedDescription)")
                completion(nil, error)
            }
            else if let currentUser = currentUser{
                print("Current user: \(currentUser)")
                
                getUserFromFirestore(uid: currentUser.uid) { document, error in
                    
                    if let error = error {
                        print("Error retrieving user: \(error.localizedDescription)")
                        completion(nil, error)
                    }
                    
                    else if let document = document {
                        let data = document.data()
                        
                        let userDoc:UserDocument
                        
                        if let firstName = data?["firstName"] as? String,
                           let lastName = data?["lastName"] as? String,
                           let position = data?["jobtitle"] as? String,
                           let accessLevel = data?["accessLevel"] as? NSNumber{
                            
                            userDoc = UserDocument(firstName: firstName, lastName: lastName, userID: currentUser.uid, email: currentUser.email ?? "Unknown", position: position, accessLevel: accessLevel.intValue)
                            
                            completion(userDoc, nil)
                            print("data is complete")
                        }
                        else {
                            completion(nil, nil) // Data is incomplete or of wrong type
                            print("User data is incomplete or of the wrong type. Data: \(String(describing: data))")
                        }
                    }
                    else {
                        completion(nil, nil)
                        print("User not found.")
                    }
                    
                    
                } // en of getUserFromFirestore
                
                
            }// end of else if let currentUser
            else{
                print("No user is currently logged in.")
                completion(nil, nil)
            }
        } // end of getCurrentUser
        
    
    }
    func getUserFromFirestore(uid: String, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
        // Assuming you have a "users" collection in Firestore
        let usersCollection = Firestore.firestore().collection("users")

        // Perform the query based on the UID
        let query = usersCollection.whereField("userID", isEqualTo: uid)

        // Get the documents that match the query
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                // Handle the error
                completion(nil, error)
                return
            }

            // Check if there are any matching documents
            guard let documents = querySnapshot?.documents else {
                // No matching documents found
                completion(nil, nil)
                return
            }

            // Assuming there is only one user with a given UID
            if let userDocument = documents.first {
                // User found, pass the document to the completion handler
                completion(userDocument, nil)
            } else {
                // No matching user found
                completion(nil, nil)
            }
        }
    }

}
