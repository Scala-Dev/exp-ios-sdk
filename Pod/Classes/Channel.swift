//
//  CommonChannel.swift
//  Pods
//
//  Created by Cesar on 12/18/15.
//
//

import Foundation
import Socket_IO_Client_Swift
import PromiseKit


public class Channel: ChannelProtocol {
    
    public typealias CallBackType = [String: AnyObject] -> Void
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
    public func broadcast(name:String,let payload:[String:AnyObject],timeout:String) -> Void{
        let msg:Dictionary<String,AnyObject> = ["name":name,"channel":generateId(),"payload":payload]
        expLogging(" BROADCAST \(msg) ")
        broadCast(timeout,params: msg)
    }
    
    /**
     Listen for particular socket name on type response broadcast
     @param  Dictionarty.
     @return Promise<Any>
     */
    public func listen(name:String, callback:CallBackType)->Promise<Any>{
        listeners.updateValue(createSubList(name, callback: callback), forKey: name)
        return subscribe(generateId())
    }
    
    /**
     Fling content
     @param  uuid String.
     @return
     */
    public func fling(payload:[String:AnyObject]) -> Void{
        let msg:Dictionary<String,AnyObject> = ["name":"fling","channel":self.channelId!,"payload":payload]
        expLogging("FLING \(msg) ")
        broadCast("2000",params: msg)
    }
    
    /**
     Handle On Broadcast callback
    */
    public func onBroadcast(dic: [String : AnyObject]) {
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
    public func subscribe(idChannel:String)->Promise<Any>{
        return self.socketManager.subscribe(idChannel)
    }
    
    
    /**
     Generate Channel ID from org,name
     */
    public func generateId()->String{
        if((channelId ?? "").isEmpty){
            let org = auth?.get("identity")!["organization"] as! String
            let systemInt:Int = self.system ? 1:0
            let consumerAppInt:Int = self.consumerApp ? 1:0
            let paramsArray = [org,self.channelName,systemInt,consumerAppInt]
            do {
                let jsonData = try NSJSONSerialization.dataWithJSONObject(paramsArray, options: [])
                let string = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
                let utf8str = string!.dataUsingEncoding(NSUTF8StringEncoding)
                channelId = (utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)))!
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
    public func identify() -> Void{
        let msg:Dictionary<String,AnyObject> = ["name":"identify","channel":self.channelId!]
        expLogging("IDENTIFY \(msg) ")
        broadCast("2000",params: msg)
    }
    
    /**
     * Create Subscriber list
     * @param name
     * @param callback
     * @return
     */
    private func createSubList(name:String, callback:CallBackType)->[CallBackType]{
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
