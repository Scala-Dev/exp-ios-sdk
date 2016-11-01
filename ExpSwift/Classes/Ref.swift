//
//  Ref.swift
//  Pods
//
//  Created by Cesar on 9/10/15.
//
//

import Foundation


public final class Ref: ResponseObject,ResponseCollection {
     let major: String
     let minor: String
     let manufacturer: String
     let proximityUuid: String
     let primaryType: String
     let uuid: String?
     let org: String?
     let subtype: String
     let name: String
    
    required public init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: AnyObject],
            let major = representation["major"] as? String,
            let minor = representation["minor"] as? String,
            let manufacturer = representation["manufacturer"] as? String,
            let proximityUuid = representation["proximityUuid"] as? String,
            let primaryType = representation["primaryType"] as? String,
            let uuid = representation["uuid"] as? String,
            let org = representation["org"] as? String,
            let subtype = representation["subtype"] as? String,
            let name = representation["name"] as? String
        else { return nil }
        
        self.major = major
        self.minor = minor
        self.manufacturer = manufacturer
        self.proximityUuid = proximityUuid
        self.primaryType = primaryType
        self.uuid = uuid
        self.org = org
        self.subtype = subtype
        self.name = name
    }
    
    
    
    
    
    public static func collection(response: HTTPURLResponse, representation: Any) -> [Ref] {
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
