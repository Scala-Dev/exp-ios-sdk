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
    
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            self.uuid = representation["uuid"] as! String
        } else {
            self.uuid = ""
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
    
}
