//
//  Zone.swift
//  Pods
//
//  Created by Cesar on 9/10/15.
//
//

import Foundation


public final class Zone: Model,ResponseObject,ResponseCollection {

    public let name: String
    public let key: String
    
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            self.name = representation["name"] as! String
            self.key = representation["key"] as! String
        } else {
            self.name = ""
            self.key = ""
        }
        
        super.init(response: response, representation: representation)
    }

    public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Zone] {
        var zones: [Zone] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for zoneRepresentation in representation {
                if let zone = Zone(response: response, representation: zoneRepresentation) {
                    zones.append(zone)
                }
            }
        }
        return zones
    }
    
}
