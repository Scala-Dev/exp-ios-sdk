//
//  Channel.swift
//  Pods
//
//  Created by Cesar on 9/22/15.
//
//

import Foundation
import PromiseKit
import SocketIO

public protocol ChannelProtocol {

     associatedtype CallBackType
     func onBroadcast(_ dic:[String:Any])
     func broadcast(_ name:String,payload:[String:Any],timeout:String)
     func listen(_ name:String, callback:CallBackType)->Promise<Any>
     func fling(_ dic:[String:Any])
     func identify()

}
