//
//  LoginViewController.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 9/17/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        emailTextField.keyboardType = UIKeyboardType.emailAddress
    }
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func loginTapped(_ sender: Any) {
        
        let error = validateTextField()
        if error != nil {
            errorLabel.text = error
            errorLabel.alpha = 1
            return
        }
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                //could not sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
//                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainHomeVC) as? MainHomeViewController
//
//                self.view.window?.rootViewController = homeViewController
//                self.view.window?.makeKeyAndVisible()
                self.transitionToHome()
            }
            
        }
        
    }
    
    func transitionToHome(){
//        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainHomeVC) as! MainHomeViewController
//
//        view.window?.rootViewController = homeViewController
//        view.window?.makeKeyAndVisible()
        
//        let rootVC:LoginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        let nvc:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainNavController) as! UINavigationController
        
        view.window?.rootViewController = nvc
        view.window?.makeKeyAndVisible()
        
//        nvc.pushViewController(homeViewController, animated: true)
        
    }
    
    //******************************
    func validateTextField() -> String? {
        
        // check all field are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all text fields!"
        }
        // check email is in the correct format
        let emailcheck = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if CorrectFormat.isValidEmail(emailcheck) == false {
            // email incorrect format
            return "Incorrect email format"
        }
        
        
        return nil
    }

}
