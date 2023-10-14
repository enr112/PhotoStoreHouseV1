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
    
    @IBOutlet weak var stackView: UIStackView!
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        let numOfColumns = 3
        //let width = stackView.frame.size.width - CGFloat((numOfColumns-1) * 10))/ CGFloat(numOfColumns)
        let width = (self.view.frame.size.width - CGFloat((numOfColumns-1) * 10)) / CGFloat(numOfColumns)
        let layout = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: width, height: width)
    }
    func setUpElements(){
        Utilities.styleHollowButton(choosePhotoButton)
    }

    @IBAction func presentPicker(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0 // multi-selection support
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
}
extension UploadPhotoVC: PHPickerViewControllerDelegate {
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    self.imageArray.append(image)
                }
                DispatchQueue.main.async {
                    self.imageCollectionView.reloadData()
                }
            }
        }
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
    
    
}
