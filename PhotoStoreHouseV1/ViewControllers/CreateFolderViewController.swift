//
//  CreateFolderViewController.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 9/27/23.
//

import UIKit

class CreateFolderViewController: UIViewController {

    @IBOutlet var folderNameTextField: UITextField!
//    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var createFolderButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureKeyboardHandling()
        // Add explicit width constraint
        //view.widthAnchor.constraint(equalToConstant: 350).isActive = true
        folderNameTextField.delegate = self
        folderNameTextField.returnKeyType = .done
        folderNameTextField.clearButtonMode = .whileEditing
        
        
        // Add explicit height constraint
        //view.heightAnchor.constraint(equalToConstant: 375).isActive = true
        folderNameTextField.layer.borderColor = CGColor(red: 166/255, green: 207/255, blue: 152/255, alpha: 1)
        folderNameTextField.layer.borderWidth = 2.2
        setUpElements()
        getUser()
    }
    deinit {
        // Remove keyboard handling when the view controller is deallocated
        removeKeyboardHandling()
    }

    func setUpElements(){
        errorLabel.alpha = 0
        
//        Utilities.styleTextField(folderNameTextField)
        Utilities.styleHollowButton(cancelButton)
        Utilities.styleHollowButton(createFolderButton)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        folderNameTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createFolderButtonTapped(_ sender: UIButton) {
        if folderNameTextField.text == "" {
            errorLabel.text = "Folder name cannot be empty"
            errorLabel.alpha = 1
            return
        }
        

        if let folderName = folderNameTextField.text {
            
            if !CorrectFormat.isValidFolderName(folderName){
                errorLabel.text = "Incorrect name format (cannot contain spaces, starts or contains special symbols, should be at least 3 characters long). Only symbols allowed within name are: - and _"
                errorLabel.font = UIFont.systemFont(ofSize: 15)
                errorLabel.alpha = 1
                return
            }
            
            RetrieveFolders.createFolderDocument(folderName: folderName) { result in
                switch result {
                case .success(let message):
                    // Handle success as needed
                    print("Task was successful")
                    self.errorLabel.textColor = UIColor.black
                    self.errorLabel.text = message
                    self.cancelButton.setTitle("Exit", for: .normal)
                    self.createFolderButton.isEnabled = false
                    self.errorLabel.alpha = 1
                    self.folderNameTextField.resignFirstResponder()

                case .failure(let error):
                    switch error {
                    case .folderExists:
                        print("Folder already exists \(error.localizedDescription)")
                        // Handle the case where the folder already exists
                        self.errorLabel.text = "Folder already exists-->\(error.localizedDescription)"
                        self.errorLabel.alpha = 1
                    default:
                        print("Could not complete task: \(error.localizedDescription)")
                        // Handle other failure cases
                        self.errorLabel.text = "Could not create folder--> \(error.localizedDescription)"
                        self.errorLabel.alpha = 1
                    }
                }
            }
        }
        
    }
    
    // get currently logged in user
    func getUser(){
        let userObj = ManageUsers()
        
        userObj.getCurrentUser { userDoc, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")

            }
            else if let userDoc = userDoc{
                print("User fetched successfully: \(userDoc)")
            }
            else {
                print("User document not found.")
            }
            
        }
    }

}
extension CreateFolderViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // This method is called when the return key is tapped on the keyboard
        textField.resignFirstResponder() // Dismiss the keyboard
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // This method is called when the user taps outside the text field
        view.endEditing(true) // Dismiss the keyboard
    }
//    func textFieldShouldClear(_ textField: UITextField) -> Bool{
//        return true
//    }
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
//        return false
//    }
}
