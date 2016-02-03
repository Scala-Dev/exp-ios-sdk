//
//  SocketManager.swift
//  Pods
//
//  Created by Cesar on 9/17/15.
//
//

import Foundation
import Socket_IO_Client_Swift
import PromiseKit


public  class SocketManager {
    
    public var socket:SocketIOClient?
    var channelFactory:ChannelFactory = ChannelFactory()
    public typealias CallBackTypeConnection = String -> Void
    public typealias CallBackType = [String: AnyObject] -> Void
    var responders = [String: CallBackType]()
    var connection = [String: CallBackTypeConnection]()
    var subscription = [String]()
    var subscriptionPromise = [String:Any]()
    var channelCache = [String:Channel]()
    var channels = [String:Channel]()

   
    
    /**
        Start the Socket Connection and init the different channel
        @return Promise<Bool>.
    */
    public func start_socket() -> Promise<Bool> {
        self.socket = SocketIOClient(socketURL: hostSocket, options: ["log": true,
        "reconnects": true,
        "reconnectAttempts": 5,
        "reconnectWait": 5,
        "connectParams": ["token":tokenSDK]])
        expLogging("Starting EXP Socket Connection Host= \(hostSocket) Token= \(tokenSDK)")
     
        
        return Promise { fulfill, reject in
            self.socket!.on("connect") {data, ack in
                expLogging("EXP socket connected")
                fulfill(true)
                if((self.connection.indexForKey(Config.ONLINE)) != nil){
                    let callBack = self.connection[Config.ONLINE]!
                    callBack(Config.ONLINE)
                }
                
            }
            self.socket!.on("disconnect") {data, ack in
                expLogging("EXP socket disconnected")
                if((self.connection.indexForKey(Config.OFFLINE)) != nil){
                    let callBack = self.connection[Config.OFFLINE]!
                    callBack(Config.OFFLINE)
                }
                //do subscribe to the channels
                self.subscribeChannels()
            }
            self.socket!.on("broadcast"){data, ack in
                expLogging("EXP BROADCAST data \(data)")
                let dic = data[0] as! NSDictionary
                let channelID = dic.valueForKey("channel") as! String
                if((self.channels.indexForKey(channelID)) != nil){
                    let channel=self.channels[channelID]! as Channel
                    channel.onBroadcast(dic)
                }
            }
            self.socket!.on("channels"){data, ack in
                expLogging("EXP channels data \(data)")
            }
            self.socket!.on("subscribed"){data, ack in
                expLogging("EXP subscribed data \(data)")
                let response = data[0] as! NSArray
                for (_, element) in response.enumerate() {
                    let id:String = element as! String
                    if((self.subscriptionPromise.indexForKey(id)) != nil){
                        var dictionary:Dictionary<String,Any> = self.subscriptionPromise[id] as! Dictionary
                        let fun = dictionary["fulfill"] as! Any -> Void
                        fun(id) //resolve  promise
                        self.subscriptionPromise.removeValueForKey(id)
                    }
                }
            }
            self.socket!.connect()
        }
    }
    
    
    /**
     Subscribe channels to socket connection
     */
    public func subscribe(idChannel:String)->Promise<Any>{
        if(subscription.indexOf(idChannel) == nil){
            subscription.append(idChannel)
            self.socket!.emit("subscribe", subscription)
        }
        let subscribePromise = Promise<Any> { fulfill, reject in
            var promiseDic = Dictionary<String,Any>()
            promiseDic  = [ "fulfill": fulfill,"reject":reject]
            if(subscriptionPromise.indexForKey(idChannel) == nil){
               subscriptionPromise.updateValue(promiseDic, forKey: idChannel)
            }
        }
        return subscribePromise
    }
    
    /**
    Listen for particular socket name on type response broadcast
    @param  Dictionarty.
    @return Promise<Any>
    */
    public func connection(name:String, callback:CallBackTypeConnection){
        connection.updateValue(callback, forKey: name)
    }
    
    
    /**
        Get Dynamic Channel by String 
        @param channel String
        @return CommonChannel
     */
    public func getChannel(nameChannel:String) -> Channel{
        let channel:Channel
        if(channelCache.indexForKey(nameChannel) != nil){
            channel = channelCache[nameChannel]!
        }else{
            channel = channelFactory.produceChannel(nameChannel, socket: socketManager)
            channels.updateValue(channel, forKey: channel.generateId())
            channelCache.updateValue(channel, forKey: nameChannel)
        }
        return channel
    }
    
    
    /**
    Disconnect from exp and remove token
    */
    public func disconnect(){
        self.socket!.close()
        self.subscriptionPromise = [:]
        self.subscription = []
        self.channels = [:]
        self.channelCache = [:]
    }
    
    /**
        Refresh Socket Connection
    */
    public func refreshConnection(){
        self.socket!.close()
        self.socket!.connect()
        subscribeChannels()
        expLogging("EXP refresh socket connection")
    }
    
    /**
     Subscribe the channels when there is a disconnect
     */
    public func subscribeChannels(){
        self.subscription = []
        self.subscriptionPromise = [:]
        for (channelId, _) in channels {
            subscribe(channelId)
        }
    }
}