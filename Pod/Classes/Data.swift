//
//  Data.swift
//  Pods
//
//  Created by Adam Galloway on 10/7/15.
//
//

import Foundation

public final class Data: Model,ResponseObject,ResponseCollection {

    public let group: String
    public let key: String
    
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            self.group = representation["group"] as! String
            self.key = representation["key"] as! String
        } else {
            self.group = ""
            self.key = ""
        }
        
        super.init(response: response, representation: representation)
    }
    
     public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Data] {
        var dataItems: [Data] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for dataRepresentation in representation {
                if let data = Data(response: response, representation: dataRepresentation) {
                    dataItems.append(data)
                }
            }
        }
        return dataItems
    }
    

}