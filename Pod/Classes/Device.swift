//
//  Device.swift
//
//
//  Created by Cesar on 9/8/15.
//
//

import Foundation


public final class Device: ResponseObject,ResponseCollection {
    public let name: String
    public let experienceUuid: String
    public let org: String
    public let uuid: String
    public let primaryType: String
    public let subtype: String
    public let zoneUuid: String?
    public let status: Bool

    @objc required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.name = representation.valueForKeyPath("name") as! String
        self.experienceUuid = representation.valueForKeyPath("experienceUuid") as! String
        self.org = representation.valueForKeyPath("org") as! String
        self.uuid = representation.valueForKeyPath("uuid") as! String
        self.primaryType = representation.valueForKeyPath("primaryType") as! String
        self.subtype = representation.valueForKeyPath("subtype") as! String
        self.zoneUuid = representation.valueForKeyPath("zoneUuid") as? String
        self.status = representation.valueForKeyPath("status") as! Bool
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
