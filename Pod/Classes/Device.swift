//
//  Device.swift
//
//
//  Created by Cesar on 9/8/15.
//
//

import Foundation


public final class Device: Model,ResponseObject,ResponseCollection {
    
    public let uuid: String

    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            self.uuid = representation["uuid"] as! String
        } else {
            self.uuid = ""
        }
        
        super.init(response: response, representation: representation)
    }
    
    public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Device] {
        var devices: [Device] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for deviceRepresentation in representation {
                if let device = Device(response: response, representation: deviceRepresentation) {
                    devices.append(device)
                }
            }
        }
        return devices
    }
    
}
