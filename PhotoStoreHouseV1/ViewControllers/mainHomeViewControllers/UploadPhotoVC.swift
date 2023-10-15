//
//  UploadPhotoVC.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 10/7/23.
//

import UIKit
import PhotosUI

class UploadPhotoVC: UIViewController {

    @IBOutlet weak var choosePhotoButton: UIButton!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var tapPhotoLabel: UILabel!
   // @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var upLoadButton: UIBarButtonItem!
    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        upLoadButton.isHidden = true
        setUpElements()
        tapPhotoLabel.isHidden = true
        tapPhotoLabel.text = "Tap on a photo(s) to add a description."
        tapPhotoLabel.textColor = .systemBlue
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        let numOfColumns = 3
        let width = (self.view.frame.size.width - CGFloat((numOfColumns-1) * 10)) / CGFloat(numOfColumns)
        let layout = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: width, height: width)
    }
    func setUpElements(){
        Utilities.styleHollowButton(choosePhotoButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let index = imageCollectionView.indexPathsForSelectedItems?.first else {
            return
        }
        
        let selectedImage = imageArray[index.item]
        
        if segue.identifier == Constants.Storyboard.photoDesptionVC {
            guard let destinationVC = segue.destination as? PhotoDescriptionVC else {
                return
            }
            destinationVC.recievedData = selectedImage
        }
    }

    @IBAction func presentPicker(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0 // multi-selection support
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
        
        //updateUI()
        
    }
    func collectionIsEmpty() ->Bool{
        return imageCollectionView.numberOfItems(inSection: 0) == 0
        // return imageCollectionView.accessibilityTraits.isEmpty
    }
    func updateUI(){
        if collectionIsEmpty(){
            tapPhotoLabel.isHidden = true
            upLoadButton.isHidden = true
        }
        else {
            tapPhotoLabel.isHidden = false
            upLoadButton.isHidden = false
        }
    }
    //MARK: -upload
    
}
extension UploadPhotoVC: PHPickerViewControllerDelegate {
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        for result in results {
            //updateUI()
            result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    self.imageArray.append(image)
                }
                DispatchQueue.main.async {
                    self.imageCollectionView.reloadData()
                    self.updateUI()
                }
            }
            // updateUI()
        }
        //updateUI()
    }
}

extension UploadPhotoVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Storyboard.uploadCell, for: indexPath) as? UploadCell else {
            return UICollectionViewCell()
        }
        cell.displayImage.image = imageArray[indexPath.item]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seletedData = imageArray[indexPath.item]
        self.performSegue(withIdentifier: Constants.Storyboard.photoDesptionVC, sender: seletedData)
    }
}
