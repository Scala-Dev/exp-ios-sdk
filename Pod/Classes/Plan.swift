//
//  Plan.swift
//  Pods
//
//  Created by Cesar on 9/9/15.
//
//

import Foundation

public final class Plan: ResponseObject,ResponseCollection {
    public let deviceUuid: String
    public let appUuid: String
    public let uuid: String
    public let name: String

    
    
    @objc required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.deviceUuid = representation.valueForKeyPath("deviceUuid") as! String
        self.appUuid = representation.valueForKeyPath("appUuid") as! String
        self.uuid = representation.valueForKeyPath("uuid") as! String
        self.name = representation.valueForKeyPath("name") as! String
    }
    
    @objc public static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Plan] {
        var plans: [Plan] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for locationRepresentation in representation {
                if let plan = Plan(response: response, representation: locationRepresentation) {
                    plans.append(plan)
                }
            }
        }
        return plans
    }
}
