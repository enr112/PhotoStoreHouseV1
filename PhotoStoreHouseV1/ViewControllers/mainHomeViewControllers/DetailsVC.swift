//
//  DetailsVC.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 11/18/23.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
//    var image: UIImage{
//        get {
//            return imageView.image ?? UIImage()
//        }
//        set{
//            imageView.image = newValue
//        }
//    }
    var image: UIImage? {
        didSet {
            if isViewLoaded {
                imageView.image = image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
    

}
