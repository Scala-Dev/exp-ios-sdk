//
//  Feed.swift
//  Pods
//
//  Created by Adam Galloway on 12/3/15.
//
//

import Foundation
import PromiseKit
import Alamofire

public final class Feed: Model,ResponseObject,ResponseCollection,ModelProtocol {
    
    public let uuid: String
    
    required public init?(response: HTTPURLResponse?, representation: Any?) {
        if let representation = representation as? [String: AnyObject] {
            self.uuid = representation["uuid"] as! String
        } else {
            self.uuid = ""
        }
        super.init(response: response, representation: representation)
    }
    
    /**
     Get output from Feed
     @return Promise<AnyObject>.
     */
    public func getData() ->Promise<Any>{
        return Promise { fulfill, reject in
            Alamofire.request(Router.getFeedData(uuid))
                .responseJSON {response in
                    switch response.result {
                    case .success(let data):
                        fulfill(data)
                    case .failure(let error):
                        return reject(error)
                    }
                }
        }  
    }
    

      public func getData(_ query:[String:Any]) ->Promise<Any>{
        return Promise { fulfill, reject in
            Alamofire.request(Router.getDynamicFeedData(uuid,query))
                .responseJSON {response in
                    switch response.result {
                    case .success(let data):
                        fulfill(data)
                    case .failure(let error):
                        return reject(error)
                    }
                }
        }  
    }
    
    /**
     Refresh Feed
     @return Promise<Feed>
     */
    public func refresh() -> Promise<Feed> {
        return getFeed(getUuid())
    }
    
    /**
     Save Feed
     @return Promise<Feed>
     */
    public func save() -> Promise<Feed> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.saveFeed(uuid,getDocument())).validate()
                .responseObject { (response: DataResponse<Feed>) in
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



