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
    
    @objc required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            self.name = representation["name"] as! String
        } else {
            self.name = ""
        }
        
        super.init(response: response, representation: representation)
    }

    @objc public static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Zone] {
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
