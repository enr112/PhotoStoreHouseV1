//
//  PhotoDescriptionVC.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 10/14/23.
//

import UIKit

class PhotoDescriptionVC: UIViewController {
    
    @IBOutlet weak var photoDescription: UITextView!
    @IBOutlet weak var photoLocation: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var recievedData:UIImage?
    
    // closure property that sets photo description in UploadPhotoVC
    var descriptionHandler: ((String?) -> Void)?
    // closure property that sets photo location in UploadPhotoVC
    var locationHandler: ((String?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUp()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    private func setUp(){
        imageView.image = recievedData
        photoDescription.layer.cornerRadius = 15
        photoLocation.layer.cornerRadius = 15
        photoLocation.text = nil
        photoDescription.text = nil
//        photoDescription.returnKeyType = .done
//        photoLocation.returnKeyType = .done
        
        photoDescription.autocorrectionType = UITextAutocorrectionType.yes
        photoDescription.spellCheckingType = UITextSpellCheckingType.yes
        
        photoLocation.autocorrectionType = UITextAutocorrectionType.yes
        photoLocation.spellCheckingType = UITextSpellCheckingType.yes
        
        saveButton.isHidden = true
        
        setupKeyboardHidding()
        self.photoDescription.delegate = self
        self.photoLocation.delegate = self
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        self.view.endEditing(true)
//        //self.photoDescription.resignFirstResponder()
//    }
    
    private func setupKeyboardHidding(){
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(PhotoDescriptionVC.keyboardWillShow(sender:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(PhotoDescriptionVC.keyboardWillShow(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        if let desc = photoDescription {
            print(desc)
        }
        else {
            debugPrint("description is nil")
        }
        if let location = photoLocation {
            debugPrint(location)
        }
        else {
            debugPrint("location is nil")
        }
        
        descriptionHandler?(photoDescription.text)
        photoDescription.isEditable = false
        photoDescription.backgroundColor = UIColor(red: 25/255, green: 105/255, blue: 105/255, alpha: 0.65)
        
        locationHandler?(photoLocation.text)
        photoLocation.isEditable = false
        photoLocation.backgroundColor = UIColor(red: 25/255, green: 105/255, blue: 105/255, alpha: 0.65)
        
        
        saveButton.isHidden = true
        
      /*
        if photoLocation.text != nil{
            print(photoLocation.text!)
            photoLocation.isEditable = false
            photoLocation.backgroundColor = UIColor(red: 25/255, green: 105/255, blue: 105/255, alpha: 0.65)
            saveButton.isHidden = true
            
        }
        else {
            print("photo location is empty")
            return
        }
        if photoDescription != nil{
            print(photoDescription.text!)
            photoDescription.isEditable = false
            photoDescription.backgroundColor = UIColor(red: 25/255, green: 105/255, blue: 105/255, alpha: 0.65)
            saveButton.isHidden = true
            //descriptionHandler?(photoDescription.text)
            
        }
        else {
            print("photo description is nil")
            return
        }
       */
    }
    
}
extension PhotoDescriptionVC {
    
    // shift view when keyboard appears
    @objc func keyboardWillShow(sender: NSNotification){
        
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextView = UIResponder.currentFirst() as? UITextView else {
            return
        }
        // check if the top of the keyboard is above the bottom of the currently focused textbox
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextViewFrame = view.convert(currentTextView.frame, from: currentTextView.superview)
        let textViewdBottomY = convertedTextViewFrame.origin.y + convertedTextViewFrame.size.height

        // if textField bottom is below keyboard bottom - bump the frame up
       if textViewdBottomY > keyboardTopY {
            let textBoxY = convertedTextViewFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY
 
        }


    }
    
    @objc func keyboardWillHide(){
        view.frame.origin.y = 0
    }
    
    
}

extension PhotoDescriptionVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView){
       // saveButton.isHidden = false
        textView.backgroundColor = UIColor(red: 237/255, green: 228/255, blue: 255/255, alpha: 0.75)

        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
//        guard let currentTextView = UIResponder.currentFirst() as? UITextView else {
//        return
//        }
//        currentTextView.text = nil
        textView.backgroundColor = UIColor.systemBackground
    }
    func textViewDidChange(_ textView: UITextView)
    {
        saveButton.isHidden = false
        textView.backgroundColor = UIColor(red: 255/255, green: 105/255, blue: 105/255, alpha: 0.65)
     //   print(textView.text ?? "Empty text view")
    }
}

