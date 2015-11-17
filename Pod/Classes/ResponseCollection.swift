//
//  ResponseCollection.swift
//  Pods
//
//  Created by Cesar on 9/8/15.
//
//

import Foundation
import Alamofire


public protocol ResponseCollection {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

extension Alamofire.Request {
    public func responseCollection<T: ResponseCollection>(completionHandler: Response<[T], NSError> -> Void) -> Self {
        
        let responseSerializer = ResponseSerializer<[T], NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let response = response {
                    debugPrint(value)
                    return .Success(T.collection(response: response, representation: value))
                } else {
                    let failureReason = "Response collection could not be serialized due to nil response"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
//        let responseSerializer = GenericResponseSerializer<SearchResults<T>> { request, response, data in
//            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
//            let (JSON: AnyObject?, serializationError) = JSONSerializer.serializeResponse(request, response, data)
//            let result = JSON as? NSDictionary
//            
//            let codeKey: AnyObject? = result?["code"]
//            if codeKey == nil{
//                let results: AnyObject? = result?["results"]
//                if let response = response, results: AnyObject = results {
//                    let total: Int64 = (result?["total"] as! NSNumber).longLongValue
//                    let collection: [T] = T.collection(response: response, representation: results)
//
//                    let searchResults = SearchResults<T>(results: collection, total: total)
//                    
//                    return (searchResults, nil)
//                } else {
//                    return (nil, serializationError)
//                }
//            }else{
//                // if there is ERROR return the message and code error
//                let code:String = codeKey as! String
//                let message:String = result?["message"] as! String
//                return (nil, NSError(domain: hostUrl, code: Config.EXP_REST_API_ERROR, userInfo: ["code":code,"message":message]))
//            }
        
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)

    }
}