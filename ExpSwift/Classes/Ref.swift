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
    
    required public init?(response: HTTPURLResponse, representation: AnyObject) {
        self.major = representation.value(forKeyPath: "major") as! String
        self.minor = representation.value(forKeyPath: "minor") as! String
        self.manufacturer = representation.value(forKeyPath: "manufacturer") as! String
        self.proximityUuid = representation.value(forKeyPath: "proximityUuid") as! String
        self.primaryType = representation.value(forKeyPath: "primaryType") as! String
        self.uuid = representation.value(forKeyPath: "uuid") as? String
        self.org = representation.value(forKeyPath: "org") as? String
        self.subtype = representation.value(forKeyPath: "subtype") as! String
        self.name = representation.value(forKeyPath: "name") as! String
    }
    
    
    
    
    
    public static func collection(response: HTTPURLResponse, representation: AnyObject) -> [Ref] {
        var refs: [Ref] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for refRepresentation in representation {
                if let ref = Ref(response: response, representation: refRepresentation as AnyObject) {
                    refs.append(ref)
                }
            }
        }
        return refs
    }
}
