//
//  Token.swift
//  Pods
//
//  Created by Cesar on 9/24/15.
//
//

import Foundation
public final class Token: ResponseObject {
    
    public let token: String
    
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.token = representation.valueForKeyPath("token") as! String
    }
}
