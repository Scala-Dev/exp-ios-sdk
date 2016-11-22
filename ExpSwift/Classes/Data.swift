//
//  Data.swift
//  Pods
//
//  Created by Adam Galloway on 10/7/15.
//
//

import Foundation
import PromiseKit

public final class Data: Model,ResponseObject,ResponseCollection {

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
}

extension ExpModel where Self: Data {
    func refresh() -> Promise<Data> {
        return getData(self.group,key: self.key)
    }
}
