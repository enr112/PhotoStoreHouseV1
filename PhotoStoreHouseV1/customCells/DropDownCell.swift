//
//  FolderDropDownCell.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 11/12/23.
//

import UIKit
import DropDown

class FolderDropDownCell: DropDownCell {
    
    @IBOutlet var folderIcon:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        optionLabel?.backgroundColor = UIColor(red: 135/255, green: 196/255, blue: 255/255, alpha: 1.0)
        optionLabel?.layer.cornerRadius = 15 //(optionLabel?.frame.size.height)!/2.0
        optionLabel?.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
