//
//  ResponseCollection.swift
//  Pods
//
//  Created by Cesar on 9/8/15.
//
//

import Foundation
import Alamofire


@objc public protocol ResponseCollection {
    static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

extension Alamofire.Request {
    public func responseCollection<T: ResponseCollection>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, SearchResults<T>?, NSError?) -> Void) -> Self {
        let responseSerializer = GenericResponseSerializer<SearchResults<T>> { request, response, data in
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let (JSON: AnyObject?, serializationError) = JSONSerializer.serializeResponse(request, response, data)
            let result = JSON as? NSDictionary
            
            let codeKey: AnyObject? = result?["code"]
            if codeKey == nil{
                let results: AnyObject? = result?["results"]
                if let response = response, results: AnyObject = results {
                    let total: Int64 = result?["total"] as! Int64
                    let collection: [T] = T.collection(response: response, representation: results)

                    let searchResults = SearchResults<T>(results: collection, total: total)
                    
                    return (searchResults, nil)
                } else {
                    return (nil, serializationError)
                }
            }else{
                // if there is ERROR return the message and code error
                let code:String = codeKey as! String
                let message:String = result?["message"] as! String
                return (nil, NSError(domain: hostUrl, code: Config.EXP_REST_API_ERROR, userInfo: ["code":code,"message":message]))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}