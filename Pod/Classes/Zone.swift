//
//  Zone.swift
//  Pods
//
//  Created by Cesar on 9/10/15.
//
//

import Foundation


public final class Zone: ResponseObject,ResponseCollection {
    public let name: String?
    public let locationUuid: String?
    public let proximity: Proximity?
    public let uuid: String
    public let org: String
    public let labels: [String]


    
    @objc required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.name = representation.valueForKeyPath("name") as? String
        self.locationUuid = representation.valueForKeyPath("locationUuid") as? String
        self.proximity = Proximity(response:response, representation: representation.valueForKeyPath("proximity")!)!
        self.uuid = representation.valueForKeyPath("uuid") as! String
        self.org = representation.valueForKeyPath("org") as! String
        self.labels = representation.valueForKeyPath("labels") as! NSArray as! [String]
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
