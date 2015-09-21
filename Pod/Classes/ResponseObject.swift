//
//  ResponseObject.swift
//  Pods
//
//  Created by Cesar on 9/8/15.
//
//

import Foundation
import Alamofire


@objc public protocol ResponseObject {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}

extension Request {
    public func responseObject<T: ResponseObject>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, T?, NSError?) -> Void) -> Self {
        
        let responseSerializer = GenericResponseSerializer<T> { request, response, data in
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let (JSON: AnyObject?, serializationError) = JSONResponseSerializer.serializeResponse(request, response, data)
            let result = JSON as? NSDictionary
            let codeKey: AnyObject? = result?["code"]
            if codeKey == nil{
                if let response = response, JSON: AnyObject = JSON {
                    return (T(response: response, representation: JSON), nil)
                } else {
                    return (nil,serializationError)
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

