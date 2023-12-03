//
//  MainHomeViewController.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 9/17/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MainHomeViewController: UIViewController {
    @IBOutlet weak var availableFoldersLabel: UILabel!
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    var folderNames = [String]()
    
    var folderNamesHandler: (([String]) -> Void)?
    
    @IBOutlet weak var foldersCollectionView: UICollectionView!
    
    // refresh to update new folders created
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboardHandling()
        
        retrieveFolderNames()
        // set title
        self.title = "Home"
        setLayout()
        
        foldersCollectionView.delegate = self
        foldersCollectionView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshFolderNames), for: UIControl.Event.valueChanged)
        foldersCollectionView.refreshControl = refreshControl
        
    }
    deinit {
        // Unregister from keyboard notifications when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
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
    // sign user out

    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            
                // Navigate to the initial view controller
                let initialNavController:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.initialNavController) as! UINavigationController

                view.window?.rootViewController = initialNavController
                view.window?.makeKeyAndVisible()
            
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    @IBAction func createFolderButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.createFolderVC) as? CreateFolderViewController {
            popUpViewController.modalPresentationStyle = .popover
            popUpViewController.preferredContentSize = CGSizeMake(350, 400)
            print("Presented view controller size: \(popUpViewController.view.frame.size)")

            if let popoverPresentationController = popUpViewController.popoverPresentationController {
                popoverPresentationController.sourceView = sender
                popoverPresentationController.sourceRect = sender.bounds
                //popoverPresentationController.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.minY, width: 0, height: 0)
                popoverPresentationController.permittedArrowDirections = .up

//                popUpViewController.preferredContentSize = CGSizeMake(350, 400)
                // Set up the delegate for more control
                popoverPresentationController.delegate = self

                // Present the view controller
//                present(popUpViewController, animated: true) {
//                    // Check the size after presentation
//                    print("Presented view controller size: \(popUpViewController.view.frame.size)")
//                }
            }
            // Present the view controller
            present(popUpViewController, animated: true) {
                // Check the size after presentation
                print("Presented view controller size: \(popUpViewController.view.frame.size)")
            }
        }
        
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
        RetrieveFolders.retrieveFolderNames { folderNames in
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
    // retrieve new folder names when new is created
    @objc func refreshFolderNames(){
        retrieveFolderNames()
        self.foldersCollectionView.refreshControl?.endRefreshing()
    }
}
extension MainHomeViewController: UIPopoverPresentationControllerDelegate{
//    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .popover
//    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
