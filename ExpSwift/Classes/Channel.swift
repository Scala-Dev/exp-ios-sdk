//
//  CommonChannel.swift
//  Pods
//
//  Created by Cesar on 12/18/15.
//
//

import Foundation
import SocketIO
import PromiseKit


open class Channel: ChannelProtocol {
    
    public typealias CallBackType = ([String: Any]) -> Void
    var listeners = [String: [CallBackType]]()
    var responders = [String: CallBackType]()
    var socketManager:SocketManager
    var channelName:String
    var system:Bool
    var consumerApp:Bool
    var channelId:String?
    
    public required init(socket socketC:SocketManager,nameChannel:String,system:Bool,consumerApp:Bool) {
        self.socketManager=socketC
        self.channelName=nameChannel
        self.system = system
        self.consumerApp = consumerApp
    }

    
    /**
     Send socket type broadcast with Dictionary
     @param  Dictionarty.
     @return Promise<Any>
     */
    open func broadcast(_ name:String, payload:[String:Any],timeout:String) -> Void{
        let msg:Dictionary<String,Any> = ["name":name,"channel":generateId(),"payload":payload]
        expLogging(" BROADCAST \(msg) ")
        broadCast(timeout,params: msg)
    }
    
    /**
     Listen for particular socket name on type response broadcast
     @param  Dictionarty.
     @return Promise<Any>
     */
    open func listen(_ name:String, callback:@escaping CallBackType)->Promise<Any>{
        listeners.updateValue(createSubList(name, callback: callback), forKey: name)
        return subscribe(generateId())
    }
    
    /**
     Fling content
     @param  uuid String.
     @return
     */
    open func fling(_ payload:[String:Any]) -> Void{
        let msg:Dictionary<String,Any> = ["name":"fling" as AnyObject,"channel":self.channelId! ,"payload":payload]
        expLogging("FLING \(msg) ")
        broadCast("2000",params: msg)
    }
    
    /**
     Handle On Broadcast callback
    */
    open func onBroadcast(_ dic: [String : Any]) {
        let name = dic["name"] as! String
        if let subscriberList = self.listeners[name] {
            for callBack in subscriberList {
                callBack(dic)
            }
        }
    }
    
    /**
     Subscribe to the channel
     */
    open func subscribe(_ idChannel:String)->Promise<Any>{
        return self.socketManager.subscribe(idChannel)
    }
    
    
    /**
     Generate Channel ID from org,name
     */
    open func generateId()->String{
        if((channelId ?? "").isEmpty){
            let identity = auth?.get("identity") as! [String:AnyObject]
            let org = identity["organization"] as! String
            let systemInt:Int = self.system ? 1:0
            let consumerAppInt:Int = self.consumerApp ? 1:0
            let paramsArray = [org,self.channelName,systemInt,consumerAppInt] as [Any]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: paramsArray, options: [])
                channelId = (jsonData as NSData).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                }catch let error as NSError{
                expLogging(error.description)
            }
            expLogging("GENERATE ID = \(channelId)")
        }
        return  channelId!
    }
    
    /**
     Identify
     @return
     */
    open func identify() -> Void{
        let msg:Dictionary<String,Any> = ["name":"identify","channel":self.channelId!]
        expLogging("IDENTIFY \(msg) ")
        broadCast("2000",params: msg)
    }
    
    /**
     * Create Subscriber list
     * @param name
     * @param callback
     * @return
     */
    fileprivate func createSubList(_ name:String, callback:@escaping CallBackType)->[CallBackType]{
        var subscriberArray: [CallBackType] = []
        if let listCallback = self.listeners[name] {
            subscriberArray = listCallback
        }else{
            self.listeners[name] = subscriberArray
        }
        subscriberArray.append(callback)
        return subscriberArray
    }

}
