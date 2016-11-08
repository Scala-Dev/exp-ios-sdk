//
//  ResponseObject.swift
//  Pods
//
//  Created by Cesar on 9/8/15.
//
//

import Foundation
import Alamofire


public protocol ResponseObject {
    init?(response: HTTPURLResponse, representation: Any)
}


extension DataRequest {
    func responseObject<T: ResponseObject>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil else {
                let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
                let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
                guard case let .success(jsonObject) = result else {
                    return .failure(BackendError.jsonSerialization(error: result.error!))
                }
                return .failure(BackendError.network(error: error!,message: jsonObject))
            }

            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(BackendError.jsonSerialization(error: result.error!))
            }
            
            guard let response = response, let responseObject = T(response: response, representation: jsonObject) else {
                return .failure(BackendError.objectSerialization(reason: "JSON could not be serialized: \(jsonObject)"))
            }
            
            return .success(responseObject)
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
