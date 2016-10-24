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
    fileprivate var location:Location?
    fileprivate var experience:Experience?
    
    required public init?(response: HTTPURLResponse, representation: AnyObject) {
        self.uuid = representation.value(forKeyPath: "uuid") as! String
        if let dic = representation.value(forKeyPath: "location")  as? NSDictionary {
            if let uuid = dic.value(forKeyPath: "uuid") as? String {
                self.location = Location(response:response, representation: representation.value(forKeyPath: "location")!)!
            }
        }
        if let dic = representation.value(forKeyPath: "experience")  as? NSDictionary {
            self.experience = Experience(response:response, representation: representation.value(forKeyPath: "experience")!)!
        }
        super.init(response: response, representation: representation)
    }
    
    public static func collection(response: HTTPURLResponse, representation: AnyObject) -> [Thing] {
        var things: [Thing] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for thingRepresentation in representation {
                if let thing = Thing(response: response, representation: thingRepresentation as AnyObject) {
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
