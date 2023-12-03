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
        
        
        // Add explicit height constraint
        //view.heightAnchor.constraint(equalToConstant: 375).isActive = true
        folderNameTextField.layer.borderColor = CGColor(red: 166/255, green: 207/255, blue: 152/255, alpha: 1)
        folderNameTextField.layer.borderWidth = 2.2
        setUpElements()
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createFolderButtonTapped(_ sender: UIButton) {
        if folderNameTextField.text == "" {
            errorLabel.text = "Folder name cannot be empty"
            errorLabel.alpha = 1
            return
        }

        if let folderName = folderNameTextField.text {
            RetrieveFolders.createFolderDocument(folderName: folderName) { result in
                switch result {
                case .success(let message):
                    print("Task was successful")
                    self.errorLabel.shadowColor = UIColor.black
                    self.errorLabel.text = message
                    self.cancelButton.setTitle("Exit", for: .normal)
                    self.createFolderButton.isEnabled = false
                    self.errorLabel.alpha = 1

                case .failure(let error):
                    print("Could not complete task: \(error)")
                    self.errorLabel.text = "Folder creation failed"
                    self.errorLabel.alpha = 1
                }
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
}
