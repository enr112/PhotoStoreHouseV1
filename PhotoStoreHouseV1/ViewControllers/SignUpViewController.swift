//
//  SignUpViewController.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 9/17/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet var firstNameTextField: UITextField!
    
    @IBOutlet var lastNameTextField: UITextField!
    
    @IBOutlet var jobTitleTextField: UITextField!
    
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
        
        // style elements on signUpViewController
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(jobTitleTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    // Validates text fields, return nil if data are correct otherwise return error message
    func validateTextField() -> String? {
        
        // check all field are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            jobTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all text fields!"
        }
        // check email is in the correct format
        let emailcheck = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isValidEmail(emailcheck) == false {
            // email incorrect format
            return "Incorrect email format"
        }
        
        // check password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // password is not secure
            return "password must contain at least 8 characters, contains a sepcial character, (# $ % @) and a number."
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        // validate text fields
        let error = validateTextField()
        
        // there is an error, user cannot sign up
        if error != nil {
            showError(error!)
        }
        else {
            // clean up data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let jobTile = jobTitleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create user
            Auth.auth().createUser(withEmail: email, password: password) { authResult, err in
              // check for errors
                if err != nil {
                    // there was an error creating user
                    self.showError(err?.localizedDescription ?? "Error creating user")
                }
                else {
                    // User was created successfully, store user data
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstName": firstName,
                                                                                    "lastName": lastName,
                                                                                    "jobtitle": jobTile,
                                                                                    "userID":authResult!.user.uid]){ (error) in
                        if error != nil {
                            self.showError("Could not save user data")
                        }
                    }
                    // Transition to main home screen
                    self.transitionToHome()
                }
            }
            
        }
        
    }
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainHomeVC) as? MainHomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
