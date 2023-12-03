//
//  ViewController+KeyboardHandling.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 12/2/23.
//

import UIKit

extension UIViewController {
    
    func configureKeyboardHandling() {
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // shift view when keyboard appears
    @objc func keyboardWillShow(sender: NSNotification){
        
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextView = UIResponder.currentFirst() as? UITextField else {
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
   /*
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            adjustViewForKeyboard(height: keyboardSize.height)
        }
    }
    */
    @objc private func keyboardWillHide(){
        view.frame.origin.y = 0
    }
    /*
    @objc private func keyboardWillHide(_ notification: Notification) {
        adjustViewForKeyboard(height: 0)
    }
    */
    private func adjustViewForKeyboard(height: CGFloat) {
        if let scrollView = self.view as? UIScrollView {
            // Adjust content insets for UIScrollView (or subclasses)
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        } else {
            // Adjust constraints or frame for other types of views
            // Customize this part based on your view hierarchy
        }
    }
    
    func removeKeyboardHandling() {
        // Unregister from keyboard notifications
        NotificationCenter.default.removeObserver(self)
    }
}
