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
    
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            self.uuid = representation["uuid"] as! String
        } else {
            self.uuid = ""
        }
        
        super.init(response: response, representation: representation)
    }
    
    public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Message] {
        var devices: [Message] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for deviceRepresentation in representation {
                if let device = Message(response: response, representation: deviceRepresentation) {
                    devices.append(device)
                }
            }
        }
        return devices
    }
    
}
