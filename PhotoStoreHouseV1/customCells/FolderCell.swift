//
//  folderCell.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 11/5/23.
//

import UIKit

class FolderCell: UICollectionViewCell {
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configureLabel(label:String){
        //TODO -write code here to update label on the cell
        // myLabel.text = label
        // https://www.youtube.com/watch?v=mwsVA2gJTTM
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        //myLabel.text = nil
    }
}
