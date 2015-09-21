//
//  Channel.swift
//  Pods
//
//  Created by Cesar on 9/22/15.
//
//

import Foundation
import PromiseKit
import Socket_IO_Client_Swift

public protocol Channel {

     typealias CallBackType
     func onResponse(responseDic: NSDictionary)
     func onRequest(responseDic: NSDictionary)
     func onBroadcast(responseDic: NSDictionary)
     func request(var messageDic: [String:String]) -> Promise<Any>
     func broadcast(var messageDic:[String:AnyObject])
     func listen(messageDic:[String: AnyObject], callback:CallBackType)
     func respond(messageDic:[String: AnyObject], callback:CallBackType)

}