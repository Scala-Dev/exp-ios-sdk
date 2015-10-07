//
//  Data.swift
//  Pods
//
//  Created by Adam Galloway on 10/7/15.
//
//

import Foundation

public final class Data: ResponseObject,ResponseCollection {
    public var document: [String:AnyObject] = [String:AnyObject]()
    
    @objc required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            for documentRep in representation{
                document.updateValue(documentRep.1, forKey: documentRep.0)
            }
        }
    }
    
    @objc public static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Data] {
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