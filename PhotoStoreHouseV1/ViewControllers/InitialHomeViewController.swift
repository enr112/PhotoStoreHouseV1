//
//  InitialHomeViewController.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 9/17/23.
//

import UIKit

class InitialHomeViewController: UIViewController {

    @IBOutlet var createAccountButton: UIButton!
    
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    func setUpElements(){
        Utilities.styleFilledButton(createAccountButton)
        Utilities.styleHollowButton(loginButton)
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
