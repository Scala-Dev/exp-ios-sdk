//
//  ChannelFactory.swift
//  Pods
//
//  Created by Cesar on 1/27/16.
//
//

import Foundation
import Socket_IO_Client_Swift

public class ChannelFactory{

    
    public func produceChannel(channelName:String,socket: SocketManager)->Channel{
        return Channel(socket: socket, nameChannel: channelName)
    }
}