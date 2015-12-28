//
//  String+EncodeURIComponent.swift
//  Pods
//
//  Created by Adam Galloway on 10/9/15.
//
//

import Foundation

extension String {
    
    func encodeURIComponent() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-_.!~*'()")
        
        return self.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
    }
}