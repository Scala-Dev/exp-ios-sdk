//
//  Location.swift
//  Pods
//
//  Created by Cesar on 9/8/15.
//
//

import Foundation
import PromiseKit
import Alamofire


public final class Location: Model,ResponseObject,ResponseCollection {

    public let uuid: String
    public var zones: [Zone] = []
    
    
    required public init?(response: HTTPURLResponse, representation: Any) {
        if let representation = representation as? [String: AnyObject] {
            self.uuid = representation["uuid"] as! String
        } else {
            self.uuid = ""
        }
        super.init(response: response, representation: representation)
        if let representation = representation as? [String: AnyObject] {
            if let zonesLocation = representation["zones"] as? [Any] {
                self.zones = Zone.collection(response:response, representation: zonesLocation,location: self)
            }
        }
    }
        
    public func getZones() -> [Zone]{
        return self.zones
    }
    
    public func getLayoutUrl() -> String {
        let rt = auth?.get("restrictedToken")
        return "\(hostUrl)/api/locations/\(self.uuid)/layout?_rt=\(rt)"
    }

    public func getDevices() -> Promise<SearchResults<Device>>{
        return Promise { fulfill, reject in
            Alamofire.request(Router.findDevices(["location.uuid":self.uuid]))
                .responseCollection { (response: DataResponse<SearchResults<Device>>) in
                    switch response.result{
                    case .success(let data):
                        fulfill(data)
                    case .failure(let error):
                        return reject(error)
                    }
            }
        }
    }
    
    public func getThings() -> Promise<SearchResults<Thing>>{
        return Promise { fulfill, reject in
            Alamofire.request(Router.findThings(["location.uuid":self.uuid]))
                .responseCollection { (response: DataResponse<SearchResults<Thing>>) in
                    switch response.result{
                    case .success(let data):
                        fulfill(data)
                    case .failure(let error):
                        return reject(error)
                    }
            }
        }
    }
    
    /**
     Get Current Location
     @return Promise<Location>.
     */
    public func getCurrentLocation() -> Promise<Location?>{
       return Device.getCurrentDevice().then{ (device:Device?) -> Promise<Location?> in
         return (device?.getLocation())!
        }
    }

}
