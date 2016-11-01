//
//  ChannelFactory.swift
//  Pods
//
//  Created by Cesar on 1/27/16.
//
//

import Foundation
import SocketIO

open class ChannelFactory{

    
    open func produceChannel(_ channelName:String,socket: SocketManager,system:Bool,consumerApp:Bool)->Channel{
        return Channel(socket: socket, nameChannel: channelName,system: system,consumerApp: consumerApp)
    }
}
