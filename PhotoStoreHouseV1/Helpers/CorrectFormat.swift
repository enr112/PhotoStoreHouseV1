//
//  CorrectFormat.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 9/28/23.
//

import Foundation

class CorrectFormat {
    
    static func isPasswordValid(_ password:String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    static func isValidFolderName(_ folderName: String) -> Bool {
        // Check if folder name is at least 3 characters long
        guard folderName.count >= 3 else {
            return false
        }
        
        // Check if folder name starts with a special symbol
        let startsWithSpecialSymbol = folderName.hasPrefix(".") || folderName.hasPrefix("-") || folderName.hasPrefix("_")
        
        // Check if folder name contains any special symbol other than dash or underscore
        let containsInvalidSymbols = folderName.rangeOfCharacter(from: CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_")) == nil
        
        // Check if folder name contains white spaces
        let containsWhiteSpaces = folderName.contains(" ")
        
        // Folder name is valid if it meets all the criteria
        return !startsWithSpecialSymbol && !containsInvalidSymbols && !containsWhiteSpaces
    }
}
