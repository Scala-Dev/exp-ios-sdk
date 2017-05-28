//
//  Zone.swift
//  Pods
//
//  Created by Cesar on 9/10/15.
//
//

import Foundation
import PromiseKit
import Alamofire

public final class Zone: Model,ResponseObject,ResponseCollection,ModelProtocol {

    public var name: String?
    public let key: String
    fileprivate var location: Location?
    
    required public init?(response: HTTPURLResponse?, representation: Any?) {
        guard
            let representation = representation as? [String: Any],
            let key = representation["key"] as? String,
            let name = representation["name"] as? String
            else{ return nil}
        self.key = key
        self.name = name
        super.init(response: response, representation: representation)
    }

    public static func collection(response: HTTPURLResponse?, representation: Any?,location: Location?) -> [Zone] {
        var zones: [Zone] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for zoneRepresentation in representation {
                if let zone = Zone(response: response, representation: zoneRepresentation as AnyObject) {
                    zone.location = location
                    zones.append(zone)
                }
            }
        }
        
        return zones
    }
    
    public func getDevices() -> Promise<SearchResults<Device>>{
        return Promise { fulfill, reject in
            let uuidLocation:String = (self.location?.uuid)!
            Alamofire.request(Router.findDevices(["location.uuid":uuidLocation,"location.zones.key":self.key]))
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
            Alamofire.request(Router.findThings(["location.uuid":self.location!.uuid,"location.zones.key":self.key]))
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
     Get Current Zones
     @return Promise<[Zone]>.
     */
    public func getCurrentZones() -> Promise<[Zone?]>{
        return Device.getCurrentDevice().then{ (device:Device?) -> Promise<[Zone?]> in
            return Promise<[Zone?]> { fulfill, reject in
                if let zones:[Zone] = device?.getZones(){
                    fulfill(zones)
                }else{
                    fulfill([])
                    expLogging("Zone - getCurrentZones NULL")
                }
            }
        }
    }
    
    /**
     Get Channel Name
     */
    override public func getChannelName() -> String {
        return (self.location?.uuid)!+":zone:"+self.key
    }
    
    /**
     Refresh Zone by calling the location
     @return Promise<Location>
     */
    public func refresh() -> Promise<Location> {
        return (self.location?.refresh())!
    }
    
    /**
     Save Zone by calling the location
     @return Promise<Location>
     */
    public func save() -> Promise<Location> {
        return (self.location?.save())!
    }
}

