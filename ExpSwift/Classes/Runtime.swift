//
//  Runtime.swift
//  Pods
//
//  Created by Cesar on 9/28/15.
//
//

import Foundation
import SocketIO
import Alamofire
import PromiseKit
import JWT

open class Runtime{
    
    var optionsRuntime = [String: AnyObject]()
    var timeout:TimeInterval = 5 // seconds
    var enableSocket:Bool = true // enable socket connection
    
    
    /**
    Initialize the SDK and connect to EXP.
    @param host,uuid,secret.
    @return Promise<Bool>.
    */
    open func start(_ host: String, uuid: String, secret: String)  -> Promise<Bool> {
       return start(["host": host as AnyObject, "deviceUuid": uuid as AnyObject, "secret": secret as AnyObject])
    }
    
    /**
    Initialize the SDK and connect to EXP.
    @param host,user,password,organization.
    @return Promise<Bool>.
    */
    open func start(_ host:String , user: String , password:String, organization:String) -> Promise<Bool> {
        return start(["host": host as AnyObject, "username": user as AnyObject, "password": password as AnyObject, "organization": organization as AnyObject])
    }
    
    /**
     Initialize the SDK and connect to EXP.
     @param host,user,password,organization.
     @return Promise<Bool>.
     */
    open func start(_ host:String , auth: Auth) -> Promise<Bool> {
        return start(["host": host as AnyObject, "auth": auth])
    }

    
    
    /**
     Initialize the SDK and connect to EXP.
     @param options
     @return Promise<Bool>.
     */
    open func start(_ options:[String:AnyObject]) -> Promise<Bool> {
        expLogging("EXP start with options \(options)")
        optionsRuntime = options
        return Promise { fulfill, reject in
            
            if let host = options["host"] {
                hostUrl=host as! String
            }
            
            if let enableEvents = options["enableEvents"]{
                self.enableSocket = NSString(string: (enableEvents as? String)!).boolValue
            }
            
            if let user = options["username"], let password = options["password"], let organization = options["organization"] {
                login(options).then {(auth: Auth) -> Void  in
                    self.initNetwork(auth)
                    if self.enableSocket {
                        socketManager.start_socket().then { (result: Bool) -> Void  in
                            if result{
                                fulfill(true)
                            }
                        }
                    }
                }
            }
            
            if let uuid = options["uuid"] as? String, let secret = options["secret"] as? String {
                let tokenSign = JWT.encode(["uuid": uuid, "type": "device"], algorithm: .hs256(secret.data(using: .utf8)!))
                login(["token":tokenSign as AnyObject]).then {(auth: Auth) -> Void  in
                    self.initNetwork(auth)
                    if self.enableSocket {
                        socketManager.start_socket().then { (result: Bool) -> Void  in
                            if result{
                                fulfill(true)
                            }
                        }
                    }
                }
            }
            
            if let uuid = options["deviceUuid"] as? String, let secret = options["secret"] as? String {
                let tokenSign = JWT.encode(["uuid": uuid, "type": "device"], algorithm: .hs256(secret.data(using: .utf8)!))
                login(["token":tokenSign as AnyObject]).then {(auth: Auth) -> Void  in
                    self.initNetwork(auth)
                    if self.enableSocket {
                        socketManager.start_socket().then { (result: Bool) -> Void  in
                            if result{
                                fulfill(true)
                            }
                        }
                    }
                }
                
            }
            
            if let uuid = options["uuid"] as? String, let apiKey = options["apiKey"] as? String {
                let tokenSign = JWT.encode(["uuid": uuid, "type": "consumerApp"], algorithm: .hs256(apiKey.data(using: .utf8)!))
                login(["token":tokenSign as AnyObject]).then {(auth: Auth) -> Void  in
                    self.initNetwork(auth)
                    if self.enableSocket {
                        socketManager.start_socket().then { (result: Bool) -> Void  in
                            if result{
                                fulfill(true)
                            }
                        }
                    }
                }
            }
            
            if let uuid = options["consumerAppUuid"] as? String, let apiKey = options["apiKey"] as? String {
                let tokenSign = JWT.encode(["uuid": uuid, "type": "consumerApp"], algorithm: .hs256(apiKey.data(using: .utf8)!))
                login(["token":tokenSign as AnyObject]).then {(auth: Auth) -> Void  in
                    self.initNetwork(auth)
                    if self.enableSocket {
                        socketManager.start_socket().then { (result: Bool) -> Void  in
                            if result{
                                fulfill(true)
                            }
                        }
                    }
                }
            }
            
            if let uuid = options["networkUuid"] as? String, let apiKey = options["apiKey"] as? String{
                let tokenSign = JWT.encode(["uuid": uuid, "type": "consumerApp"], algorithm: .hs256(apiKey.data(using: .utf8)!))
                login(["token":tokenSign as AnyObject]).then {(auth: Auth) -> Void  in
                    self.initNetwork(auth)
                    if self.enableSocket {
                        socketManager.start_socket().then { (result: Bool) -> Void  in
                            if result{
                                fulfill(true)
                            }
                        }
                    }
                }
            }
            
            if let auth = options["auth"] as? Auth{
                let tokenSign = auth.getToken()
                login(["token":tokenSign as AnyObject]).then {(auth: Auth) -> Void  in
                    self.initNetwork(auth)
                    if self.enableSocket {
                        socketManager.start_socket().then { (result: Bool) -> Void  in
                            if result{
                                fulfill(true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /**
     Init network parameters for socket connection and Api calls
     @param auth
     */
    fileprivate func initNetwork(_ auth: Auth)->Void{
        tokenSDK = auth.get("token") as! String
        let networks = auth.get("network") as! NSDictionary
        hostSocket = networks["host"] as! String
    }
    
    /**
    Stop socket connection.
    @param host,user,password,organization.
    @return Promise<Bool>.
    */
    open func stop(){
        socketManager.disconnect()
        tokenSDK = ""
    }

    /**
    Connection Socket
    @param name for connection(offline,line),callback
    @return void
    */
    open func connection(_ name:String,callback:@escaping (String)->Void){
        socketManager.connection(name,  callback: { (resultListen) -> Void in
            callback(resultListen)
        })
    }
    
    /**
     Socket Manager is Connected
     */
    open func isConnected()->Bool{
        var isConnected = false
        if(socketManager != nil){
            isConnected =  socketManager.isConnected()
        }
        return isConnected
    }
    

    
}
