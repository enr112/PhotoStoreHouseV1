//
//  MainHomeViewController.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 9/17/23.
//

import UIKit
import FirebaseFirestore

class MainHomeViewController: UIViewController {
    @IBOutlet weak var availableFoldersLabel: UILabel!
    
    var folderNames = [String]()
    
    var folderNamesHandler: (([String]) -> Void)?
    
    @IBOutlet weak var foldersCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveFolderNames()
        // set title
        self.title = "Home"
        setLayout()
        
        foldersCollectionView.delegate = self
        foldersCollectionView.dataSource = self
        
    }
    func setLayout(){
        let device = UIDevice.current.model
        var numOfColumns:Int
        
        var addToHeight:Int
        
        if currentOrientation() == "portrait" || currentOrientation() == "portraitUpSideDown"{
            if device == "iPad"{
                numOfColumns = 5
                addToHeight = 25
            }
            else {
                addToHeight = 40
                numOfColumns = 4
            }
        }
        else if currentOrientation() == "landscape" {
            if device == "iPad"{
                numOfColumns = 2 * 5
                addToHeight = 25
            }
            else {
                addToHeight = 40
                numOfColumns = 2 * 4
            }
        }
        else{
            if device == "iPad"{
                numOfColumns = 5
                addToHeight = 25
            }
            else {
                addToHeight = 40
                numOfColumns = 4
            }
        }
        
        // let width = (self.view.frame.size.width - CGFloat((numOfColumns-1) * 10)) / CGFloat(numOfColumns)
        let layout = foldersCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let width = (self.view.frame.size.width - CGFloat((numOfColumns-1) * 4)) / CGFloat(numOfColumns)
        
        layout.itemSize = CGSize(width: width, height: width+CGFloat(addToHeight))
        
    }
    // detect device orientaion
    func currentOrientation()->String{
        let currentOrientation = self.deviceOrientation()
        var orientaion:String
        
        switch currentOrientation {
        case .portrait:
            orientaion = "portrait"
            debugPrint("Portrait")
        case .landscapeLeft, .landscapeRight:
            orientaion = "landscape"
            debugPrint("landscapeLeft or landScapeRight")
        case .portraitUpsideDown:
            orientaion = "portraitUpSideDown"
            debugPrint("PortraitUpSideDown")
        case .unknown, .faceUp, .faceDown:
            orientaion = "unknown"
            debugPrint("faceUp or faceDown")
        @unknown default:
            fatalError("Unable to detect device orientation")
        }
        return orientaion
    }

}

//MARK -manage folders collection view
extension MainHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folderNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.identifier, for: indexPath) as? FolderCell else{
            return UICollectionViewCell()
        }
        //cell.contentView.backgroundColor = .systemCyan
        let folderName = folderNames[indexPath.item]
        //cell.configureLabel(label: "Folder \(indexPath.item)")
        cell.configureLabel(label: folderName)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle item selection
            let toPhotosCollectionVc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.toPhotosCollectionVc) as! PhotosCollectionVC
        toPhotosCollectionVc.setFolderName = folderNames[indexPath.item]
            
            navigationController?.pushViewController(toPhotosCollectionVc, animated: true)
    }
}

// Retrieve folder name from

extension MainHomeViewController {
    
    func retrieveFolderNames(){
        FolderNames.retrieveFolderNames { folderNames in
            if let folderNames = folderNames {
                // Use the retrieved folder names here
                self.folderNames = folderNames
                print("Retrieved folder names: \(folderNames)")
                // Reload the collection view data on the main thread
                DispatchQueue.main.async {
                    self.foldersCollectionView.reloadData()
                }
                
            } else {
                // Handle the error
                self.availableFoldersLabel.text = "Failed to retrieve folders"
            }
        }
        
    }
}
