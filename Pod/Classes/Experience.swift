//
//  Experience.swift
//  Pods
//
//  Created by Cesar on 9/9/15.
//
//

import Foundation



public final class Experience: ResponseObject,ResponseCollection {
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
    
    
    @objc public static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Experience] {
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
