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


public final class Experience: Model,ResponseObject,ResponseCollection,ModelProtocol {

    public let uuid: String
    
    required public init?(response: HTTPURLResponse, representation: Any) {
        if let representation = representation as? [String: AnyObject] {
            self.uuid = representation["uuid"] as! String
        } else {
            self.uuid = ""
        }

        super.init(response: response, representation: representation)
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
    
    /**
     Get Current Experience
     @return Promise<Experience>.
     */
    public func getCurrentExperience() -> Promise<Experience?>{
        return Device.getCurrentDevice().then{ (device:Device?) -> Promise<Experience?> in
            return (device?.getExperience())!
        }
    }
    
    /**
     Refresh Experience
     @return Promise<Experience>
     */
    public func refresh() -> Promise<Experience> {
        return getExperience(getUuid())
    }
    
    /**
     Save Experience
     @return Promise<Experience>
     */
    public func save() -> Promise<Experience> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.saveExperience(getUuid(),document)).validate()
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
}


