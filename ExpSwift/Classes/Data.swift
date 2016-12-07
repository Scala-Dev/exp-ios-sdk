//
//  Data.swift
//  Pods
//
//  Created by Adam Galloway on 10/7/15.
//
//

import Foundation
import PromiseKit
import Alamofire

public final class Data: Model,ResponseObject,ResponseCollection,ModelProtocol {

    public let group: String
    public let key: String
    
    required public init?(response: HTTPURLResponse, representation: Any) {
        if let representation = representation as? [String: AnyObject] {
            self.group = representation["group"] as! String
            self.key = representation["key"] as! String
        } else {
            self.group = ""
            self.key = ""
        }
        super.init(response: response, representation: representation)
    }
    
    public override func getChannelName() -> String {
        return "data:" + self.key + self.group
    }
    
    public func getValue() -> [String:Any]{
        return get("value") as! [String : Any]
    }
    
    /**
     Refresh Data
     @return Promise<Data>
     */
    public func refresh() -> Promise<Data> {
        return getData(self.group,key: self.key)
    }
    
    /**
     Save Data
     @return Promise<Data>
     */
    public func save() -> Promise<Data> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.createData(self.group, self.key, getDocument())).validate()
                .responseObject { (response: DataResponse<Data>) in
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


