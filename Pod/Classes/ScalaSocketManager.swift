//
//  ScalaSocketManager.swift
//  Pods
//
//  Created by Cesar on 9/17/15.
//
//

import Foundation
import Socket_IO_Client_Swift
import PromiseKit


public  class ScalaSocketManager {
    
    public var socket = SocketIOClient(socketURL: hostUrl, options: ["log": false,
        "reconnects": true,
        "reconnectAttempts": 5,
        "reconnectWait": 5,
        "connectParams": ["token":tokenSDK]])
    
    var scalaOrgChannel: ScalaOrgCh?
    var scalaLocationChannel:ScalaLocationCh?
    var scalaSystemChannel:ScalaSystemCh?
    var scalaExperienceChannel:ScalaExperienceCh?
    var request = [String: Any]()
    public typealias CallBackType = [String: AnyObject] -> Void
    var listeners = [String: CallBackType]()
    var responders = [String: CallBackType]()
   
    
    /**
        Start the Socket Connection and init the different channel
        @return Promise<Bool>.
    */
    public func start_socket() -> Promise<Bool> {
        
        //init channels
        scalaOrgChannel = ScalaOrgCh(socket: self.socket)
        scalaSystemChannel = ScalaSystemCh(socket: self.socket)
        scalaLocationChannel = ScalaLocationCh(socket: self.socket)
        scalaExperienceChannel = ScalaExperienceCh(socket: self.socket)
        
        return Promise { fulfill, reject in
            self.socket.on("connect") {data, ack in
                println("socket connected")
                fulfill(true)
            }
            self.socket.on(ScalaConfig.SOCKET_MESSAGE) {data, ack in
                var response = data?.firstObject as! NSDictionary
                let type = response["type"] as! String
                let channel: AnyObject? = response["channel"]
                if ( ScalaConfig.RESPONSE == type ){
                    //if channel is null call all the channels
                    if(channel == nil){
                        self.scalaSystemChannel?.onResponse(response)
                        self.scalaLocationChannel?.onResponse(response)
                        self.scalaExperienceChannel?.onResponse(response)
                        self.scalaOrgChannel?.onResponse(response)
                    }else{
                        let channelEnum:SCALA_SOCKET_CHANNELS = SCALA_SOCKET_CHANNELS(rawValue: channel as! String)!
                        switch channelEnum{
                            case .SYSTEM :
                                self.scalaSystemChannel?.onResponse(response)
                            case .LOCATION:
                                self.scalaLocationChannel?.onResponse(response)
                            case .EXPERIENCE:
                                self.scalaExperienceChannel?.onResponse(response)
                            case .ORGANIZATION:
                                self.scalaOrgChannel?.onResponse(response)
                            default:
                                self.scalaSystemChannel?.onResponse(response)
                        }
                    }
                    
                }else if( ScalaConfig.REQUEST == type ){
                    //if channel is null call all the channels
                    if(channel == nil){
                        self.scalaSystemChannel?.onRequest(response)
                        self.scalaLocationChannel?.onRequest(response)
                        self.scalaExperienceChannel?.onRequest(response)
                        self.scalaOrgChannel?.onRequest(response)
                    }else{
                        let channelEnum:SCALA_SOCKET_CHANNELS = SCALA_SOCKET_CHANNELS(rawValue: channel as! String)!
                        switch channelEnum{
                            case .SYSTEM :
                                self.scalaSystemChannel?.onRequest(response)
                            case .LOCATION:
                                self.scalaLocationChannel?.onRequest(response)
                            case .EXPERIENCE:
                                self.scalaExperienceChannel?.onRequest(response)
                            case .ORGANIZATION:
                                self.scalaOrgChannel?.onRequest(response)
                            default:
                                self.scalaSystemChannel?.onRequest(response)
                        }
                    }
                }else if( ScalaConfig.BROADCAST == type ){
                    //if channel is null call all the channels
                    if(channel == nil){
                        self.scalaSystemChannel?.onBroadCast(response)
                        self.scalaLocationChannel?.onBroadCast(response)
                        self.scalaExperienceChannel?.onBroadCast(response)
                        self.scalaOrgChannel?.onBroadCast(response)
                    }else{
                        let channelEnum:SCALA_SOCKET_CHANNELS = SCALA_SOCKET_CHANNELS(rawValue: channel as! String)!
                        switch channelEnum{
                            case .SYSTEM :
                                self.scalaSystemChannel?.onBroadCast(response)
                            case .LOCATION:
                                self.scalaLocationChannel?.onBroadCast(response)
                            case .EXPERIENCE:
                                self.scalaExperienceChannel?.onBroadCast(response)
                            case .ORGANIZATION:
                                self.scalaOrgChannel?.onBroadCast(response)
                            default:
                                self.scalaSystemChannel?.onBroadCast(response)
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
        var msg:Dictionary<String,String> = ["type": "request", "name": "getCurrentExperience"]
        let sysCh:ScalaSystemCh = getChannel(SCALA_SOCKET_CHANNELS.SYSTEM) as! ScalaSystemCh
        return sysCh.request(msg)
    }
    
    /**
        Get Current Device (Socket Method)
        @return Promise<Any>.
    */
    public func getCurrentDevice() ->Promise<Any>{
        var msg:Dictionary<String,String> = ["type": "request", "name": "getCurrentDevice"]
        let sysCh:ScalaSystemCh = getChannel(SCALA_SOCKET_CHANNELS.SYSTEM) as! ScalaSystemCh
        return sysCh.request(msg)
    }

    /**
        Get Socket Channel By Enum
        @param enum SCALA_SOCKET_CHANNELS. default is SYSTEM CHANNEL
        @return AnyObject (ScalaOrgCh,ScalaLocationCh,ScalaSystemCh,ScalaExperienceCh).
    */
    public func getChannel(typeChannel:SCALA_SOCKET_CHANNELS) -> AnyObject{
        switch typeChannel{
            case .SYSTEM:
                return  scalaSystemChannel!
            case .LOCATION:
                return scalaLocationChannel!
            case .ORGANIZATION:
                return scalaOrgChannel!
            case .EXPERIENCE:
                return scalaExperienceChannel!
            default:
                return scalaSystemChannel!
        }
    }
    
}