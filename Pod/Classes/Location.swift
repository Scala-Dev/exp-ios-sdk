//
//  Location.swift
//  Pods
//
//  Created by Cesar on 9/8/15.
//
//

import Foundation


public final class Location: ResponseObject,ResponseCollection {
    public let name: String
    public let street: String
    public let city: String
    public let state: String
    public let zip: String
    public let country: String?
    public let telephone: String?
    public let uuid: String
    public let org: String
    public let labels: [String]
    
    @objc required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.name = representation.valueForKeyPath("name") as! String
        self.street = representation.valueForKeyPath("street") as! String
        self.city = representation.valueForKeyPath("city") as! String
        self.state = representation.valueForKeyPath("state") as! String
        self.zip = representation.valueForKeyPath("zip") as! String
        self.country = representation.valueForKeyPath("country") as? String
        self.telephone = representation.valueForKeyPath("telephone") as? String
        self.uuid = representation.valueForKeyPath("uuid") as! String
        self.org = representation.valueForKeyPath("org") as! String
        self.labels = representation.valueForKeyPath("labels") as! NSArray as! [String]
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
