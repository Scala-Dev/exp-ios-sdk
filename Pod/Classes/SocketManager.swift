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
    
    public var socket = SocketIOClient(socketURL: hostUrl, options: ["log": false,
        "reconnects": true,
        "reconnectAttempts": 5,
        "reconnectWait": 5,
        "connectParams": ["token":tokenSDK]])
    
    var organizationChannel: OrganizationChannel?
    var locationChannel:LocationChannel?
    var systemChannel:SystemChannel?
    var experienceChannel:ExperienceChannel?
    var request = [String: Any]()
    public typealias CallBackTypeConnection = String -> Void
    public typealias CallBackType = [String: AnyObject] -> Void
    var listeners = [String: CallBackType]()
    var responders = [String: CallBackType]()
    var connection = [String: CallBackTypeConnection]()
    var channelCache = [String: CommonChannel]()
   
    
    /**
        Start the Socket Connection and init the different channel
        @return Promise<Bool>.
    */
    public func start_socket() -> Promise<Bool> {
        
        //init channels
        organizationChannel = OrganizationChannel(socket: self.socket)
        systemChannel = SystemChannel(socket: self.socket)
        locationChannel = LocationChannel(socket: self.socket)
        experienceChannel = ExperienceChannel(socket: self.socket)
        
        return Promise { fulfill, reject in
            self.socket.on("connect") {data, ack in
                fulfill(true)
                if((self.connection.indexForKey(Config.ONLINE)) != nil){
                    let callBack = self.connection[Config.ONLINE]!
                    callBack(Config.ONLINE)
                }
                
            }
            self.socket.on("disconnect") {data, ack in
                if((self.connection.indexForKey(Config.OFFLINE)) != nil){
                    let callBack = self.connection[Config.OFFLINE]!
                    callBack(Config.OFFLINE)
                }

            }
            self.socket.on(Config.SOCKET_MESSAGE) {data, ack in
                let response = data[0] as! NSDictionary
                let type = response.objectForKey("type") as! String
                let channel: AnyObject? = response.objectForKey("channel")
                if ( Config.RESPONSE == type ){
                    //if channel is null call all the channels
                    if(channel == nil){
                        self.systemChannel?.onResponse(response)
                        self.locationChannel?.onResponse(response)
                        self.experienceChannel?.onResponse(response)
                        self.organizationChannel?.onResponse(response)
                    }else{
                        if let channelEnum:SOCKET_CHANNELS = SOCKET_CHANNELS(rawValue: channel as! String)!{
                            switch channelEnum{
                            case .SYSTEM :
                                self.systemChannel?.onResponse(response)
                            case .LOCATION:
                                self.locationChannel?.onResponse(response)
                            case .EXPERIENCE:
                                self.experienceChannel?.onResponse(response)
                            case .ORGANIZATION:
                                self.organizationChannel?.onResponse(response)
                            }
                        }else if(self.channelCache.indexForKey(channel as! String) != nil){
                            let commChannel:CommonChannel = self.channelCache[channel as! String]!
                            commChannel.onResponse(response)
                        }
                    }
                    
                }else if( Config.REQUEST == type ){
                    //if channel is null call all the channels
                    if(channel == nil){
                        self.systemChannel?.onRequest(response)
                        self.locationChannel?.onRequest(response)
                        self.experienceChannel?.onRequest(response)
                        self.organizationChannel?.onRequest(response)
                    }else{
                        if let channelEnum:SOCKET_CHANNELS = SOCKET_CHANNELS(rawValue: channel as! String)!{
                            switch channelEnum{
                                case .SYSTEM :
                                    self.systemChannel?.onRequest(response)
                                case .LOCATION:
                                    self.locationChannel?.onRequest(response)
                                case .EXPERIENCE:
                                    self.experienceChannel?.onRequest(response)
                                case .ORGANIZATION:
                                    self.organizationChannel?.onRequest(response)
                            }
                        }else if(self.channelCache.indexForKey(channel as! String) != nil){
                                let commChannel:CommonChannel = self.channelCache[channel as! String]!
                                commChannel.onRequest(response)
                        }
                    }
                }else if( Config.BROADCAST == type ){
                    //if channel is null call all the channels
                    if(channel == nil){
                        self.systemChannel?.onBroadcast(response)
                        self.locationChannel?.onBroadcast(response)
                        self.experienceChannel?.onBroadcast(response)
                        self.organizationChannel?.onBroadcast(response)
                    }else{
                        if let channelEnum:SOCKET_CHANNELS = SOCKET_CHANNELS(rawValue: channel as! String)!{
                            switch channelEnum{
                                case .SYSTEM :
                                    self.systemChannel?.onBroadcast(response)
                                case .LOCATION:
                                    self.locationChannel?.onBroadcast(response)
                                case .EXPERIENCE:
                                    self.experienceChannel?.onBroadcast(response)
                                case .ORGANIZATION:
                                    self.organizationChannel?.onBroadcast(response)
                            }
                        }else if(self.channelCache.indexForKey(channel as! String) != nil){
                                let commChannel:CommonChannel = self.channelCache[channel as! String]!
                                commChannel.onBroadcast(response)
                        }
                    }

                }
            }
            self.socket.connect()
        }
        
    }
    
    /**
        Get Current Experience (Socket Method)
        @return Promise<Any>.
    */
    public func getCurrentExperience() ->Promise<Any>{
        let msg:Dictionary<String,String> = ["type": "request", "name": "getCurrentExperience"]
        return systemChannel!.request(msg)
    }
    
    /**
        Get Current Device (Socket Method)
        @return Promise<Any>.
    */
    public func getCurrentDevice() ->Promise<Any>{
        let msg:Dictionary<String,String> = ["type": "request", "name": "getCurrentDevice"]
        return systemChannel!.request(msg)
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
        Get Socket Channel By Enum
        @param enum SOCKET_CHANNELS. default is SYSTEM CHANNEL
        @return AnyObject (OrganizationChannel,LocationChannel,SystemChannel,ExperienceChannel).
    */
    public func getChannel(typeChannel:SOCKET_CHANNELS) -> Any{
        switch typeChannel{
            case .SYSTEM:
                return systemChannel!
            case .LOCATION:
                return locationChannel!
            case .ORGANIZATION:
                return organizationChannel!
            case .EXPERIENCE:
                return experienceChannel!
        }
    
    }
    
    /**
        Get Dynamic Channel by String 
        @param channel String
        @return CommonChannel
     */
    public func getChannel(channel:String) -> CommonChannel{
        let commonCh:CommonChannel
        if(channelCache.indexForKey(channel) != nil){
            commonCh = channelCache[channel]!
        }else{
            commonCh = CommonChannel(socket:self.socket,nameChannel: channel)
            channelCache.updateValue(commonCh, forKey: channel)
        }
        return commonCh
    }
    
    
    /**
    Disconnect from exp and remove token
    */
    public func disconnect(){
         self.socket.close()
         self.channelCache = [:]
    }
    
}