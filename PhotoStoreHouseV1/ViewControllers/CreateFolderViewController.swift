//
//  CreateFolderViewController.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 9/27/23.
//

import UIKit

class CreateFolderViewController: UIViewController {

    @IBOutlet var folderNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
        
        Utilities.styleTextField(folderNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleHollowButton(cancelButton)
        Utilities.styleHollowButton(doneButton)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if folderNameTextField.text == "" || emailTextField.text == "" {
            errorLabel.text = "Folder name or email \ncannot be empty"
            errorLabel.alpha = 1
            return
        }
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
