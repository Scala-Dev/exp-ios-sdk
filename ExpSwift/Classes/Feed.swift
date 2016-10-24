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
    
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            self.uuid = representation["uuid"] as! String
        } else {
            self.uuid = ""
        }
        
        super.init(response: response, representation: representation)
    }
    
    public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Feed] {
        var feeds: [Feed] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for deviceRepresentation in representation {
                if let feed = Feed(response: response, representation: deviceRepresentation) {
                    feeds.append(feed)
                }
            }
        }
        return feeds
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
                    case .Success(let data):
                        fulfill(data)
                    case .Failure(let error):
                        return reject(error)
                    }
                }

        }  
    }
    

      public func getData(query:[String:AnyObject]) ->Promise<AnyObject>{

        return Promise { fulfill, reject in
            Alamofire.request(Router.getDynamicFeedData(uuid,query))
                .responseJSON {response in
                    switch response.result {
                    case .Success(let data):
                        fulfill(data)
                    case .Failure(let error):
                        return reject(error)
                    }
                }

        }  
    }
}

