//
//  Runtime.swift
//  Pods
//
//  Created by Cesar on 9/28/15.
//
//

import Foundation
import Socket_IO_Client_Swift
import Alamofire
import PromiseKit
import JWT

public class Runtime{
    
    var optionsRuntime = [String: String]()
    var timeout:NSTimeInterval = 5 // seconds
    /**
    Initialize the SDK and connect to EXP.
    @param host,uuid,secret.
    @return Promise<Bool>.
    */
    public func start(host: String, uuid: String, secret: String)  -> Promise<Bool> {
        return start(["host": host, "deviceUuid": uuid, "secret": secret])
    }
    
    /**
    Initialize the SDK and connect to EXP.
    @param host,user,password,organization.
    @return Promise<Bool>.
    */
    public func start(host:String , user: String , password:String, organization:String) -> Promise<Bool> {
        return start(["host": host, "username": user, "password": password, "organization": organization])
    }

    
    
    /**
     Initialize the SDK and connect to EXP.
     @param options
     @return Promise<Bool>.
     */
    public func start(options:[String:String]) -> Promise<Bool> {
        optionsRuntime = options
        return Promise { fulfill, reject in
            
            if let host = options["host"] {
                hostUrl=host
            }
            
            if let user = options["username"], password = options["password"], organization = options["organization"] {
                login(options).then {(auth: Auth) -> Void  in
                    tokenSDK = auth.get("token") as! String
                    socketManager.start_socket().then { (result: Bool) -> Void  in
                        if result{
                            fulfill(true)
                        }
                    }
                }
            }
            
            if let uuid = options["uuid"], secret = options["secret"] {
                let tokenSign = JWT.encode(["uuid": uuid], algorithm: .HS256(secret))
                login(["token":tokenSign]).then {(auth: Auth) -> Void  in
                    tokenSDK = auth.get("token") as! String
                    socketManager.start_socket().then { (result: Bool) -> Void  in
                        if result{
                            fulfill(true)
                        }
                    }
                }
            }
            
            if let deviceUuid = options["deviceUuid"], secret = options["secret"] {
                let tokenSign = JWT.encode(["uuid": deviceUuid], algorithm: .HS256(secret))
                login(["token":tokenSign]).then {(auth: Auth) -> Void  in
                    tokenSDK = auth.get("token") as! String
                    socketManager.start_socket().then { (result: Bool) -> Void  in
                        if result{
                            fulfill(true)
                        }
                    }
                }
                
            }
            
            if let networkUuid = options["networkUuid"], apiKey = options["apiKey"] {
                let tokenSign = JWT.encode(["networkUuid": networkUuid], algorithm: .HS256(apiKey))
                login(["token":tokenSign]).then {(auth: Auth) -> Void  in
                    tokenSDK = auth.get("token") as! String
                    socketManager.start_socket().then { (result: Bool) -> Void  in
                        if result{
                            fulfill(true)
                        }
                    }
                }

                
            }
            
        }
    }

    
    /**
    Stop socket connection.
    @param host,user,password,organization.
    @return Promise<Bool>.
    */
    public func stop(){
        socketManager.disconnect()
        tokenSDK = ""
    }

    /**
    Connection Socket
    @param name for connection(offline,line),callback
    @return void
    */
    public func connection(name:String,callback:String->Void){
        socketManager.connection(name,  callback: { (resultListen) -> Void in
            callback(resultListen)
        })
    }

    
}