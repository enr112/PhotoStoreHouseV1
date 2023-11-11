//
//  PhotosCollectionVC.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 11/7/23.
//

import UIKit

class PhotosCollectionVC: UIViewController {
    @IBOutlet weak var folderNameLabel: UILabel!
    var folderName:String?
    
    var setFolderName: String {
        get {
            folderName ?? "unknown"
        }
        set{
            folderName = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        folderNameLabel.text = setFolderName
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
