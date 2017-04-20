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
    
    var optionsRuntime = [String: String]()
    var timeout:TimeInterval = 5 // seconds
    var enableSocket:Bool = true // enable socket connection
    
    /**
    Initialize the SDK and connect to EXP.
    @param host,uuid,secret.
    @return Promise<Bool>.
    */
    open func start(_ host: String, uuid: String, secret: String)  -> Promise<Bool> {
        return start(["host": host, "deviceUuid": uuid, "secret": secret])
    }
    
    /**
    Initialize the SDK and connect to EXP.
    @param host,user,password,organization.
    @return Promise<Bool>.
    */
    open func start(_ host:String , user: String , password:String, organization:String) -> Promise<Bool> {
        return start(["host": host, "username": user, "password": password, "organization": organization])
    }

    
    
    /**
     Initialize the SDK and connect to EXP.
     @param options
     @return Promise<Bool>.
     */
    open func start(_ options:[String:String]) -> Promise<Bool> {
        expLogging("EXP start with options \(options)")
        optionsRuntime = options
        return Promise { fulfill, reject in
            
            if let host = options["host"] {
                hostUrl=host
            }
            
            if let enableEvents = options["enableEvents"]{
                self.enableSocket = NSString(string: enableEvents).boolValue
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
            
            if let uuid = options["uuid"], let secret = options["secret"] {
                let tokenSign = JWT.encode(["uuid": uuid, "type": "device"], algorithm: .hs256(secret.data(using: .utf8)!))
                login(["token":tokenSign]).then {(auth: Auth) -> Void  in
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
            
            if let uuid = options["deviceUuid"], let secret = options["secret"] {
                let tokenSign = JWT.encode(["uuid": uuid, "type": "device"], algorithm: .hs256(secret.data(using: .utf8)!))
                login(["token":tokenSign]).then {(auth: Auth) -> Void  in
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
            
            if let uuid = options["uuid"], let apiKey = options["apiKey"] {
                let tokenSign = JWT.encode(["uuid": uuid, "type": "consumerApp"], algorithm: .hs256(apiKey.data(using: .utf8)!))
                login(["token":tokenSign]).then {(auth: Auth) -> Void  in
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
            
            if let uuid = options["consumerAppUuid"], let apiKey = options["apiKey"] {
                let tokenSign = JWT.encode(["uuid": uuid, "type": "consumerApp"], algorithm: .hs256(apiKey.data(using: .utf8)!))
                login(["token":tokenSign]).then {(auth: Auth) -> Void  in
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
            
            if let uuid = options["networkUuid"], let apiKey = options["apiKey"] {
                let tokenSign = JWT.encode(["uuid": uuid, "type": "consumerApp"], algorithm: .hs256(apiKey.data(using: .utf8)!))
                login(["token":tokenSign]).then {(auth: Auth) -> Void  in
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
        hostSocket = hostUrl
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
        return socketManager.isConnected()
    }
    

    
}
