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
    private var location:Location?
    private var experience:Experience?
    

    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.uuid = representation.valueForKeyPath("uuid") as! String
        if let dic = representation.valueForKeyPath("location")  as? NSDictionary {
            if let uuid = dic.valueForKeyPath("uuid") as? String {
                self.location = Location(response:response, representation: representation.valueForKeyPath("location")!)!
            }
        }
        if let dic = representation.valueForKeyPath("experience")  as? NSDictionary {
            self.experience = Experience(response:response, representation: representation.valueForKeyPath("experience")!)!
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
    
    public func getLocation() -> Location?{
        return self.location
    }
    
    public func getZones() -> [Zone]{
        var zones: [Zone] = []
        if let location = self.location {
            zones = location.getZones()
        }
        return zones
    }
    
    public func getExperience() -> Experience?{
        return self.experience
    }
}
