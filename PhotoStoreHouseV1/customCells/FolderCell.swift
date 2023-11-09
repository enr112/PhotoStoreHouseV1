//
//  folderCell.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 11/5/23.
//

import UIKit

class FolderCell: UICollectionViewCell {
    static var identifier = Constants.Storyboard.folderCell
    
    @IBOutlet weak var folderIconImageView: UIImageView!
    
    @IBOutlet weak var folderNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.folderNameLabel.textAlignment = .center
        //self.folderNameLabel.backgroundColor = .lightGray
    }
    
    public func configureLabel(label:String){
        //TODO -write code here to update label on the cell
        folderNameLabel.text = label
        // myLabel.text = label
        // https://www.youtube.com/watch?v=mwsVA2gJTTM
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        folderNameLabel.text = nil
        //myLabel.text = nil
    }
}
