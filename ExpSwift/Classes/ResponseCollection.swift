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
    static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Self]
}

extension ResponseCollection where Self: ResponseObject {
    public static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Self] {
        var collection: [Self] = []
        
        if let representation = representation as? [[String: Any]] {
            for itemRepresentation in representation {
                if let item = Self(response: response, representation: itemRepresentation) {
                    collection.append(item)
                }
            }
        }
        
        return collection
    }
}

extension DataRequest {
    @discardableResult
    func responseCollection<T: ResponseCollection>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<SearchResults<T>>) -> Void) -> Self
    {
        let responseSerializer = DataResponseSerializer<SearchResults<T>> { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error!)) }
            
            let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(BackendError.jsonSerialization(error: result.error!))
            }
            
            guard let response = response else {
                let reason = "Response collection could not be serialized due to nil response."
                return .failure(BackendError.objectSerialization(reason: reason))
            }
            let dic = jsonObject as! NSDictionary
            let results: AnyObject? = dic.object(forKey: "results") as AnyObject?
            let total: Int64 = (dic.object(forKey: "total") as! NSNumber).int64Value
            let collection: [T] = T.collection(from: response, withRepresentation: jsonObject)
            let searchResults = SearchResults<T>(results: collection, total: total)
            
            return .success(searchResults!)
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
