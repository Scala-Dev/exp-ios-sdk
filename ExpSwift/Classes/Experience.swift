//
//  Experience.swift
//  Pods
//
//  Created by Cesar on 9/9/15.
//
//

import Foundation
import PromiseKit
import Alamofire


public final class Experience: Model,ResponseObject,ResponseCollection {

    public let uuid: String
    
    required public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            self.uuid = representation["uuid"] as! String
        } else {
            self.uuid = ""
        }
        
        super.init(response: response, representation: representation)
    }
    
    
     public static func collection(response: HTTPURLResponse, representation: AnyObject) -> [Experience] {
        var experiences: [Experience] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for experienceRepresentation in representation {
                if let experience = Experience(response: response, representation: experienceRepresentation as AnyObject) {
                    experiences.append(experience)
                }
            }
        }
        return experiences
    }
    
    public func getDevices() -> Promise<SearchResults<Device>>{
        return Promise { fulfill, reject in
            Alamofire.request(Router.findDevices(["location.uuid":self.uuid as AnyObject]))
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
    
    /**
     Get Current Experience
     @return Promise<Experience>.
     */
    public func getCurrentExperience() -> Promise<Experience?>{
        return Device.getCurrentDevice().then{ (device:Device?) -> Promise<Experience?> in
            return (device?.getExperience())!
        }
    }

    
}
