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

public final class Feed: Model,ResponseObject,ResponseCollection {
    
    public let uuid: String
    
    required public init?(response: HTTPURLResponse, representation: Any) {
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
    public func getData() ->Promise<AnyObject>{

        return Promise { fulfill, reject in
            Alamofire.request(Router.getFeedData(uuid))
                .responseJSON {response in
                    switch response.result {
                    case .success(let data):
                        fulfill(data as AnyObject)
                    case .failure(let error):
                        return reject(error)
                    }
                }

        }  
    }
    

      public func getData(_ query:[String:AnyObject]) ->Promise<AnyObject>{

        return Promise { fulfill, reject in
            Alamofire.request(Router.getDynamicFeedData(uuid,query))
                .responseJSON {response in
                    switch response.result {
                    case .success(let data):
                        fulfill(data as AnyObject)
                    case .failure(let error):
                        return reject(error)
                    }
                }

        }  
    }
}

