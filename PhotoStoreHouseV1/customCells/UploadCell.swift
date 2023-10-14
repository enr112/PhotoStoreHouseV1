//
//  UploadCell.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 10/14/23.
//

import UIKit

class UploadCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var displayImage: UIImageView {
        get {
            imageView
        }
        set{
            imageView.image = newValue.image
        }
    }
    
}
