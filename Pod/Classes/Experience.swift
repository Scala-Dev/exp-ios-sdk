//
//  Experience.swift
//  Pods
//
//  Created by Cesar on 9/9/15.
//
//

import Foundation



public final class Experience: Model,ResponseObject,ResponseCollection {

    public let uuid: String
    
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            self.uuid = representation["uuid"] as! String
        } else {
            self.uuid = ""
        }
        
        super.init(response: response, representation: representation)
    }
    
    
     public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Experience] {
        var experiences: [Experience] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for experienceRepresentation in representation {
                if let experience = Experience(response: response, representation: experienceRepresentation) {
                    experiences.append(experience)
                }
            }
        }
        return experiences
    }
    
}
