//
//  User.swift
//  Pods
//
//  Created by Cesar on 1/9/17.
//
//

import Foundation

public final class User: Model,ResponseObject {

    required public init?(response: HTTPURLResponse, representation: Any) {
        let representation = representation as? [String: AnyObject]
        super.init(response: response, representation: representation!)
    }

}
