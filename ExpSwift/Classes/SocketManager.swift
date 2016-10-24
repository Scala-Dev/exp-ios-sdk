//
//  SocketManager.swift
//  Pods
//
//  Created by Cesar on 9/17/15.
//
//

import Foundation
import SocketIO
import PromiseKit


open  class SocketManager {
    
    open var socket:SocketIOClient?
    var channelFactory:ChannelFactory = ChannelFactory()
    public typealias CallBackTypeConnection = (String) -> Void
    public typealias CallBackType = ([String: AnyObject]) -> Void
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
    open func start_socket() -> Promise<Bool> {
        self.socket = SocketIOClient(socketURL: URL(string: hostSocket)!, config: [.log(true), .forcePolling(true), .connectParams(["token":tokenSDK]), .reconnects(true), .reconnectAttempts(5), .reconnectWait(5)])
        expLogging("Starting EXP Socket Connection Host= \(hostSocket) Token= \(tokenSDK)")
     
        
        return Promise { fulfill, reject in
            self.socket!.on("connect") {data, ack in
                expLogging("EXP socket connected")
                fulfill(true)
                //do subscribe to the channels
                self.subscribeChannels()
                if((self.connection.index(forKey: Config.ONLINE)) != nil){
                    let callBack = self.connection[Config.ONLINE]!
                    callBack(Config.ONLINE)
                }
                
            }
            self.socket!.on("disconnect") {data, ack in
                expLogging("EXP socket disconnected")
                if((self.connection.index(forKey: Config.OFFLINE)) != nil){
                    let callBack = self.connection[Config.OFFLINE]!
                    callBack(Config.OFFLINE)
                }
            }
            self.socket!.on("broadcast"){data, ack in
                expLogging("EXP BROADCAST data \(data)")
                let dic = data[0] as! NSDictionary
                let channelID = dic.value(forKey: "channel") as! String
                if((self.channels.index(forKey: channelID)) != nil){
                    let channel=self.channels[channelID]! as Channel
                    channel.onBroadcast(dic as! [String : AnyObject])
                }
            }
            self.socket!.on("channels"){data, ack in
                expLogging("EXP channels data \(data)")
            }
            self.socket!.on("subscribed"){data, ack in
                expLogging("EXP subscribed data \(data)")
                let response = data[0] as! NSArray
                for (_, element) in response.enumerated() {
                    let id:String = element as! String
                    if((self.subscriptionPromise.index(forKey: id)) != nil){
                        var dictionary:Dictionary<String,Any> = self.subscriptionPromise[id] as! Dictionary
                        let fun = dictionary["fulfill"] as! (Any) -> Void
                        fun(id) //resolve  promise
                        self.subscriptionPromise.removeValue(forKey: id)
                    }
                }
            }
            self.socket!.connect()
        }
    }
    
    
    /**
     Subscribe channels to socket connection
     */
    open func subscribe(_ idChannel:String)->Promise<Any>{
        if(subscription.index(of: idChannel) == nil){
            subscription.append(idChannel)
            self.socket!.emit("subscribe", subscription)
        }
        let subscribePromise = Promise<Any> { fulfill, reject in
            var promiseDic = Dictionary<String,Any>()
            promiseDic  = [ "fulfill": fulfill,"reject":reject]
            if(subscriptionPromise.index(forKey: idChannel) == nil){
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
    open func connection(_ name:String, callback:@escaping CallBackTypeConnection){
        connection.updateValue(callback, forKey: name)
    }
    
    
    /**
        Get Dynamic Channel by String 
        @param channel String
        @return CommonChannel
     */
    open func getChannel(_ nameChannel:String,system:Bool,consumerApp:Bool) -> Channel{
        let channel:Channel
        if(channelCache.index(forKey: nameChannel) != nil){
            channel = channelCache[nameChannel]!
        }else{
            channel = channelFactory.produceChannel(nameChannel, socket: socketManager,system: system,consumerApp: consumerApp)
            channels.updateValue(channel, forKey: channel.generateId())
            channelCache.updateValue(channel, forKey: nameChannel)
        }
        return channel
    }
    
    
    /**
    Disconnect from exp and remove token
    */
    open func disconnect(){
        self.socket!.disconnect()
        self.subscriptionPromise = [:]
        self.subscription = []
        self.channels = [:]
        self.channelCache = [:]
    }
    
    /**
        Refresh Socket Connection
    */
    open func refreshConnection(){
        self.socket!.disconnect()
        self.socket!.reconnect()
        subscribeChannels()
        expLogging("EXP refresh socket connection")
    }
    
    /**
     Subscribe the channels when there is a disconnect
     */
    open func subscribeChannels(){
        self.subscription = []
        self.subscriptionPromise = [:]
        for (channelId, _) in channels {
            subscribe(channelId)
        }
    }
    
    
}
