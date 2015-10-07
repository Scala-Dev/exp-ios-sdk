//
//  Device.swift
//
//
//  Created by Cesar on 9/8/15.
//
//

import Foundation


public final class Device: ResponseObject,ResponseCollection {
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
    
    @objc public static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Device] {
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
