//
//  PhotoDescriptionVC.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 10/14/23.
//

import UIKit

class PhotoDescriptionVC: UIViewController {
    
    @IBOutlet weak var imageDescription: UILabel!
    var recievedData:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageDescription.text = "\(recievedData?.debugDescription ?? "Unknown") Details "
        imageDescription.numberOfLines = 0
        imageDescription.sizeToFit()
        
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
