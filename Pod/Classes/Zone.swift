//
//  Zone.swift
//  Pods
//
//  Created by Cesar on 9/10/15.
//
//

import Foundation


public final class Zone: ResponseObject,ResponseCollection {
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
