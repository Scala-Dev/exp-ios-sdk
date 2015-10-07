//
//  Location.swift
//  Pods
//
//  Created by Cesar on 9/8/15.
//
//

import Foundation


public final class Location: ResponseObject,ResponseCollection {
    public var document: [String:AnyObject] = [String:AnyObject]()
    public let uuid: String
    
    @objc required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            for documentRep in representation{
                document.updateValue(documentRep.1, forKey: documentRep.0)
            }
            self.uuid = representation["uuid"] as! String
        } else {
            self.uuid = ""
        }
    }
    
    @objc public static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Location] {
        var locations: [Location] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for locationRepresentation in representation {
                if let location = Location(response: response, representation: locationRepresentation) {
                    locations.append(location)
                }
            }
        }
        return locations
    }
}
