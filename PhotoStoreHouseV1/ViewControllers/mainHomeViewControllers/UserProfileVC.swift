//
//  UserProfileVC.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 12/12/23.
//

import UIKit

class UserProfileVC: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var accessLevelLabel: UILabel!
    @IBOutlet weak var accessLevelTextField: UITextField!
    
    @IBOutlet weak var changePasswordButton: UIButton!
    // private var userDoc:UserDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Profile"
        
        errorLabel.isHidden = true
        // Do any additional setup after loading the view.
        setupUserInfo()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setupUserInfo(){
        let userObj = ManageUsers()
        
        userObj.getUserDocument { userDoc, error in
            
            if let error = error {
                print("Error retrieving current user: \(error.localizedDescription)")
                self.errorLabel.text = "Error retrieving current user information"
                self.errorLabel.isHidden = false
            } else if let userDoc = userDoc {
                print("User fetched successfully: \(userDoc)")
                self.firstNameTextField.text = userDoc.firstName
                self.lastNameTextField.text = userDoc.lastName
                self.emailTextField.text = userDoc.email
                self.accessLevelTextField.text = userDoc.accessLevel.codingKey.stringValue
                
            } else {
                print("User document not found or Data is incomplete or of wrong type")
                self.errorLabel.text = "User document not found or Data is incomplete or of wrong type"
                self.errorLabel.isHidden = false
            }
        }
    }
    
}
