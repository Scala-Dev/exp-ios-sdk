//
//  Auth.swift
//  Pods
//
//  Created by Cesar on 12/28/15.
//
//

import Foundation
public final class Auth: Model,ResponseObject {
    
    required public init?(response: HTTPURLResponse?, representation: Any?) {
        super.init(response: response, representation: representation)
    }
    
    
    public func getToken() -> String {
        return get("token") as! String
    }
    
    
    
    
}
