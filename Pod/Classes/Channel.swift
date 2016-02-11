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
    var listeners = [String: CallBackType]()
    var responders = [String: CallBackType]()
    var socketManager:SocketManager
    var channelName:String
    var system:Int
    var consumerApp:Int
    var channelId:String?
    
    public required init(socket socketC:SocketManager,nameChannel:String,system:Int,consumerApp:Int) {
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
        listeners.updateValue(callback, forKey: name)
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
        if let callBack = self.listeners[name] {
            callBack(dic)
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
            let paramsArray = [org,self.channelName,self.system,self.consumerApp]
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
    

}
