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
    
    
    var recievedData:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        photoDescription.delegate = self
        photoLocation.delegate = self
        imageView.image = recievedData
        photoDescription.layer.cornerRadius = 10
        photoLocation.layer.cornerRadius = 10
        photoLocation.text = ""
        photoDescription.text = ""
        
        photoDescription.autocorrectionType = UITextAutocorrectionType.yes
        photoDescription.spellCheckingType = UITextSpellCheckingType.yes
        
        photoLocation.autocorrectionType = UITextAutocorrectionType.yes
        photoLocation.spellCheckingType = UITextSpellCheckingType.yes
        
        setUp()
        
    }
    private func setUp(){
        setupKeyboardHidding()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        //self.photoDescription.resignFirstResponder()
    }
    
    private func setupKeyboardHidding(){
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(PhotoDescriptionVC.keyboardWillShow(sender:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(PhotoDescriptionVC.keyboardWillShow(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        guard let currentTextView = UIResponder.currentFirst() as? UITextView else {
        return
        }
        currentTextView.text = textView.text
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let currentTextView = UIResponder.currentFirst() as? UITextView else {
        return
        }
        currentTextView.text = nil
    }
}

