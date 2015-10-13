//
//  Location.swift
//  Pods
//
//  Created by Cesar on 9/8/15.
//
//

import Foundation


public final class Location: Model,ResponseObject,ResponseCollection {

    public let uuid: String
    
    @objc required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            self.uuid = representation["uuid"] as! String
        } else {
            self.uuid = ""
        }
        
        super.init(response: response, representation: representation)
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
