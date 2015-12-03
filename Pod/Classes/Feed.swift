//
//  Feed.swift
//  Pods
//
//  Created by Adam Galloway on 12/3/15.
//
//

import Foundation


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
        return devices
    }
    
    /**
     Get Children from Node
     @return Promise<[Content]>.
     */
    public func getData() ->Promise<AnyObject>{

        return Promise { fulfill, reject in
            Alamofire.request(Router.getFeedData(uuid) )
                .responseObject { (response: Response<AnyObject, NSError>) in
                    switch response.result{
                    case .Success(let data):
                        
                        fulfill(data)
                    case .Failure(let error):
                        return reject(error)
                    }
            }
        }
        
    }
    
}

