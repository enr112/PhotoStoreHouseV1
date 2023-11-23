//
//  DetailsVC.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 11/18/23.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var locationTextView: UITextView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var imagedoc:PhotoDocument?
    
    let photoDocument = { (document:PhotoAndFile) -> Void in
        //TODO -write coded here
    }
    var imageDocument: PhotoAndFile? {
        didSet {
            if isViewLoaded {
                imageView.image = imageDocument?.image
                imagedoc = imageDocument?.photoDocument
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = imageDocument?.image
        imagedoc = imageDocument?.photoDocument
        descriptionTextView.text = imagedoc?.description
        locationTextView.text = imagedoc?.location
        dateLabel.text = imagedoc?.timeStamp
        self.title = "Photo Details"
        descriptionTextView.isEditable = false
        locationTextView.isEditable = false
    }
    
    func testing(){
        print(imagedoc?.description ?? "imagedoc is nil --> description")
        print(imagedoc?.location ?? "imagedoc is nil --> location ")
    }

}
