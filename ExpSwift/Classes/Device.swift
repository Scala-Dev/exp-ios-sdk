//
//  Device.swift
//
//
//  Created by Cesar on 9/8/15.
//
//

import Foundation
import PromiseKit
import Alamofire


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
    
    public func getLocation() -> Promise<Location?>{
        if let uuidLocation = self.document["location.uuid"]{
            return Promise { fulfill, reject in
                Alamofire.request( Router.getLocation(uuidLocation as! String) )
                    .responseObject { (response: Response<Location, NSError>) in
                        switch response.result{
                        case .Success(let data):
                            fulfill(data)
                        case .Failure(let error):
                            return reject(error)
                        }
                }
            }
        }
        return Promise<Location?> { fulfill, reject in
            fulfill(nil)
        }

    }
    
    public func getZones() -> [Zone]{
        var zones: [Zone] = []
        if let location = self.location {
            zones = location.getZones()
        }
        return zones
    }
    
    
    public func getExperience() -> Promise<Experience?>{
        if let uuidExperience = self.document["experience.uuid"]{
            return Promise { fulfill, reject in
            Alamofire.request( Router.getExperience(uuidExperience as! String) )
                .responseObject { (response: Response<Experience, NSError>) in
                    switch response.result{
                    case .Success(let data):
                        fulfill(data)
                    case .Failure(let error):
                        return reject(error)
                    }
                }
            }
        }
        return Promise<Experience?> { fulfill, reject in
            fulfill(nil)
        }
    }
    
    /**
     Get Current Device
     @return Promise<Device>.
     */
    public static func getCurrentDevice() -> Promise<Device?>{
        if let identity:[String:AnyObject] = auth?.get("identity") as! [String:AnyObject] {
            if let uuididentity = identity["uuid"]{
             return Promise { fulfill, reject in
                Alamofire.request( Router.getDevice(uuididentity as! String) )
                    .responseObject { (response: Response<Device, NSError>) in
                        switch response.result{
                        case .Success(let data):
                            fulfill(data)
                        case .Failure(let error):
                            return reject(error)
                        }
                }
            }
        }
    }
    return Promise<Device?> { fulfill, reject in
            fulfill(nil)
        }
    }

    
}
