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
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //dateLabel.isHidden = false
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: self.bounds.height * 0.80).isActive = true
       // imageView.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
    }
    
    public func configureImage(image:UIImage){
        //TODO -write code here to update label on the cell
        imageView.image = image
        // myLabel.text = label
        // https://www.youtube.com/watch?v=mwsVA2gJTTM
    }
    public func configureDateLabel(dateLabel:String){
        self.dateLabel.text = dateLabel
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        //myLabel.text = nil
        dateLabel.text = nil
    }
    
}
