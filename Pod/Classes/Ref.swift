//
//  Ref.swift
//  Pods
//
//  Created by Cesar on 9/10/15.
//
//

import Foundation


public final class Ref: ResponseObject,ResponseCollection {
    public let major: String
    public let minor: String
    public let manufacturer: String
    public let proximityUuid: String
    public let primaryType: String
    public let uuid: String?
    public let org: String?
    public let subtype: String
    public let name: String
    
    @objc required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.major = representation.valueForKeyPath("major") as! String
        self.minor = representation.valueForKeyPath("minor") as! String
        self.manufacturer = representation.valueForKeyPath("manufacturer") as! String
        self.proximityUuid = representation.valueForKeyPath("proximityUuid") as! String
        self.primaryType = representation.valueForKeyPath("primaryType") as! String
        self.uuid = representation.valueForKeyPath("uuid") as? String
        self.org = representation.valueForKeyPath("org") as? String
        self.subtype = representation.valueForKeyPath("subtype") as! String
        self.name = representation.valueForKeyPath("name") as! String
    }
    
    
    
    
    
    public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Ref] {
        var refs: [Ref] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for refRepresentation in representation {
                if let ref = Ref(response: response, representation: refRepresentation) {
                    refs.append(ref)
                }
            }
        }
        return refs
    }
}
