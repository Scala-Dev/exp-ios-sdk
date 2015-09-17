//
//  Proximity.swift
//  Pods
//
//  Created by Cesar on 9/10/15.
//
//

import Foundation


public final class Proximity: ResponseObject {
    public let subtype: String
    public let ref: Ref
    
    @objc required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.subtype = representation.valueForKeyPath("subtype") as! String
        self.ref = Ref(response:response, representation: representation.valueForKeyPath("ref")!)!
    }
}