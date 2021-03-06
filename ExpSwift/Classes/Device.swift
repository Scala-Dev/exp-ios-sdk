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


public final class Device: Model,ResponseObject,ResponseCollection,ModelProtocol {
    
    public let uuid: String
    fileprivate var location:Location?
    fileprivate var experience:Experience?
    

    required public init?(response: HTTPURLResponse?, representation: Any?) {
        let representation = representation as? [String: AnyObject]
        self.uuid = representation?["uuid"] as! String
        if let dic = representation?["location"]  as? NSDictionary {
            if let uuid = dic.value(forKeyPath: "uuid") as? String {
                self.location = Location(response:response, representation: representation?["location"])
            }
        }
        super.init(response: response, representation: representation)
    }
    
    public func getLocation() -> Promise<Location?>{
        if let uuidLocation = self.document["location.uuid"]{
            return Promise { fulfill, reject in
                Alamofire.request( Router.getLocation(uuidLocation as! String) )
                    .responseObject { (response: DataResponse<Location>) in
                        switch response.result{
                        case .success(let data):
                            fulfill(data)
                        case .failure(let error):
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
                .responseObject { (response: DataResponse<Experience>) in
                    switch response.result{
                    case .success(let data):
                        fulfill(data)
                    case .failure(let error):
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
                    .responseObject { (response: DataResponse<Device>) in
                        switch response.result{
                        case .success(let data):
                            fulfill(data)
                        case .failure(let error):
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
    
    /**
     Refresh Device
     @return Promise<Device>
     */
    public func refresh() -> Promise<Device> {
        return getDevice(getUuid())
    }

    /**
     Save Device
     @return Promise<Device>
    */
    public func save() -> Promise<Device> {
        return Promise { fulfill, reject in
            Alamofire.request( Router.saveDevice(getUuid(),getDocument()) )
                .responseObject { (response: DataResponse<Device>) in
                    switch response.result{
                    case .success(let data):
                        fulfill(data)
                    case .failure(let error):
                        return reject(error)
                    }
            }
        }
    }
}
