//
//  Thing.swift
//  Pods
//
//  Created by Cesar on 10/22/15.
//
//

import Foundation

public final class Thing: Model,ResponseObject,ResponseCollection {
    
    public let uuid: String
    private var location:Location?
    private var experience:Experience?
    
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.uuid = representation.valueForKeyPath("uuid") as! String
        if let dic = representation.valueForKeyPath("location")  as? NSDictionary {
            if let uuid = dic.valueForKeyPath("uuid") as? String {
                self.location = Location(response:response, representation: representation.valueForKeyPath("location")!)!
            }
        }
        if let dic = representation.valueForKeyPath("experience")  as? NSDictionary {
            self.experience = Experience(response:response, representation: representation.valueForKeyPath("experience")!)!
        }
        super.init(response: response, representation: representation)
    }
    
    public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Thing] {
        var things: [Thing] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for thingRepresentation in representation {
                if let thing = Thing(response: response, representation: thingRepresentation) {
                    things.append(thing)
                }
            }
        }
        return things
    }
    
    public func getLocation() -> Location?{
        return self.location
    }
    
    public func getZones() -> [Zone]{
        var zones: [Zone] = []
        if let location = self.location {
            zones = location.getZones()
        }
        return zones
    }
    
    public func getExperience() -> Experience?{
        return self.experience
    }

    
}
