//
//  PhotoCell.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 11/13/23.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let indentifier = Constants.Storyboard.photoCell
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        errorLabel.isHidden = true
        
    }
    
    public func configureImage(image:UIImage){
        //TODO -write code here to update label on the cell
        imageView.image = image
        // myLabel.text = label
        // https://www.youtube.com/watch?v=mwsVA2gJTTM
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        //myLabel.text = nil
    }
    
}
