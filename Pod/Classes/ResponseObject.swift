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
 public func responseObject<T: ResponseObject>(completionHandler: Response<T, NSError> -> Void) -> Self {
        
        let responseSerializer = ResponseSerializer<T, NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let
                    response = response,
                    responseObject = T(response: response, representation: value)
                {
                    return .Success(responseObject)
                } else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
            
//            let (JSON: AnyObject?, serializationError) = JSONResponseSerializer.serializeResponse(request, response, data)
//            let result = JSON as? NSDictionary
//            let codeKey: AnyObject? = result?["code"]
//            if codeKey == nil{
//                if let response = response, JSON: AnyObject = JSON {
//                    return (T(response: response, representation: JSON), nil)
//                } else {
//                    return (nil,serializationError)
//                }
//                
//            }else{
//                // if there is ERROR return the message and code error
//                let code:String = codeKey as! String
//                let message:String = result?["message"] as! String
//                return (nil, NSError(domain: hostUrl, code: Config.EXP_REST_API_ERROR, userInfo: ["code":code,"message":message]))
//            } 
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

