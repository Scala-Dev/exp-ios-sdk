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

public final class Zone: Model,ResponseObject,ResponseCollectionLocation {

    public var name: String?
    public let key: String
    private var location: Location?
    
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.key = representation.valueForKeyPath("key") as! String
        if let name = representation.valueForKeyPath("name")  as? String {
             self.name = representation.valueForKeyPath("name") as! String
        }
        super.init(response: response, representation: representation)
    }

    public static func collection(response response: NSHTTPURLResponse, representation: AnyObject,location: Location) -> [Zone] {
        var zones: [Zone] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for zoneRepresentation in representation {
                if let zone = Zone(response: response, representation: zoneRepresentation) {
                    zone.location = location
                    zones.append(zone)
                }
            }
        }
        
        return zones
    }
    
    public func getDevices() -> Promise<SearchResults<Device>>{
        return Promise { fulfill, reject in
            Alamofire.request(Router.findDevices(["location.uuid":self.location!.uuid,"location.zones.key":self.key]))
                .responseCollection { (response: Response<SearchResults<Device>, NSError>) in
                    switch response.result{
                    case .Success(let data):
                        fulfill(data)
                    case .Failure(let error):
                        return reject(error)
                    }
            }
        }
    }
    
    
    public func getThings() -> Promise<SearchResults<Thing>>{
        return Promise { fulfill, reject in
            Alamofire.request(Router.findThings(["location.uuid":self.location!.uuid,"location.zones.key":self.key]))
                .responseCollection { (response: Response<SearchResults<Thing>, NSError>) in
                    switch response.result{
                    case .Success(let data):
                        fulfill(data)
                    case .Failure(let error):
                        return reject(error)
                    }
            }
        }
    }
    /**
     Get Current Zones
     @return Promise<[Zone]>.
     */
    public func getCurrentZones() -> Promise<[Zone]>{
        return Device.getCurrentDevice().then{ (device:Device) -> Promise<[Zone]> in
            return Promise<[Zone]> { fulfill, reject in
                if let zones:[Zone] = device.getZones(){
                    fulfill(zones)
                }else{
                    reject(NSError(domain: "error", code: 100, userInfo: ["message":"getCurrentZones is null"]))
                    debugPrint("Zone - getCurrentZones NULL")
                }
            }
        }
    }

}
