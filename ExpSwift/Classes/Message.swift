//
//  Message.swift
//  Pods
//
//  Created by Cesar on 1/29/16.
//
//

import Foundation
public final class Message: Model,ResponseObject,ResponseCollection {
    
    public let uuid: String
    
    required public init?(response: HTTPURLResponse, representation: Any) {
         let representation = representation as? [String: AnyObject]
         if let uuid = representation?["uuid"] as? String {
            self.uuid = (representation?["uuid"] as? String)!
         } else {
            self.uuid = ""
         }
        super.init(response: response, representation: representation)
    }
}
