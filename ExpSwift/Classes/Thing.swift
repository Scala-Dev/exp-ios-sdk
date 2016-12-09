//
//  Thing.swift
//  Pods
//
//  Created by Cesar on 10/22/15.
//
//

import Foundation
import PromiseKit
import Alamofire

public final class Thing: Model,ResponseObject,ResponseCollection,ModelProtocol {
    
    public let uuid: String
    fileprivate var location:Location?
    fileprivate var experience:Experience?
    
    required public init?(response: HTTPURLResponse, representation: Any) {
        let representation = representation as? [String: AnyObject]
        self.uuid = representation?["uuid"] as! String
        if let dic = representation?["location"]  as? NSDictionary {
            if let uuid = dic.value(forKeyPath: "uuid") as? String {
                self.location = Location(response:response, representation: representation?["location"])
            }
        }
        if let dic = representation?["experience"]  as? NSDictionary {
             if let uuid = dic.value(forKeyPath: "uuid") as? String {
               self.experience = Experience(response:response, representation: representation?["experience"])
            }
        }
        super.init(response: response, representation: representation)
    }
    
    public static func collection(response: HTTPURLResponse, representation: Any) -> [Thing] {
        var things: [Thing] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for thingRepresentation in representation {
                if let thing = Thing(response: response, representation: thingRepresentation as AnyObject) {
                    things.append(thing)
                }
            }
        }
        return things
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
    
    public func refresh() -> Promise<Thing> {
        return getThing(getUuid())
    }
    
    public func save() -> Promise<Thing> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.saveThing(getUuid(),getDocument())).validate()
                .responseObject { (response: DataResponse<Thing>) in
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




