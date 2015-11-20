//
//  Exp.swift
//  Pods
//
//  Created by Cesar on 9/4/15.
//
//

import Foundation
import Socket_IO_Client_Swift
import Alamofire
import PromiseKit
import JWT


var hostUrl: String = "https://api.exp.scala.com"
var tokenSDK: String = ""
var socketManager = SocketManager()
var runtime = Runtime()



public enum SOCKET_CHANNELS: String {
    case SYSTEM = "system"
    case ORGANIZATION = "organization"
    case LOCATION = "location"
    case EXPERIENCE = "experience"
}


enum Router: URLRequestConvertible {
    case findDevices([String: AnyObject])
    case getDevice(String)
    case getExperience(String)
    case findExperiences([String: AnyObject])
    case getLocation(String)
    case findLocations([String: AnyObject])
    case getContentNode(String)
    case findData([String: AnyObject])
    case getData(String,String)
    case getThing(String)
    case findThings([String: AnyObject])
    case login([String: AnyObject])
    var method: Alamofire.Method {
        switch self {
        case .findDevices:
            return .GET
        case .getDevice:
            return .GET
        case .getExperience:
            return .GET
        case .findExperiences:
            return .GET
        case .getLocation:
            return .GET
        case .findLocations:
            return .GET
        case .getContentNode:
            return .GET
        case .findData:
            return .GET
        case .getData:
            return .GET
        case .getThing:
            return .GET
        case .findThings:
            return .GET
        case .login:
            return .POST
        }
        
    }
    
    var path: String {
        switch self {
            case .getDevice(let uuid):
                return "/api/devices/\(uuid)"
            case .findDevices:
                return "/api/devices"
            case .getExperience(let uuid):
                return "/api/experiences/\(uuid)"
            case .findExperiences:
                return "/api/experiences"
            case .getLocation(let uuid):
                return "/api/locations/\(uuid)"
            case .findLocations:
                return "/api/locations"
            case .getContentNode(let uuid):
                return "/api/content/\(uuid)"
            case .findData:
                return "/api/data"
            case .getData(let group, let key):
                return "/api/data/\(group)/\(key)"
            case .getThing(let uuid):
                return "/api/things/\(uuid)"
            case .findThings:
                return "/api/things"
            case .login:
                return "/api/auth/login"
        }
        
    }
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: hostUrl)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("Bearer \(tokenSDK)", forHTTPHeaderField: "Authorization")
        switch self {
            case .findDevices(let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .findExperiences(let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .findLocations(let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .findData(let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .login(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            default:
                return mutableURLRequest
        }
    }
}

/**
Initialize the SDK and connect to EXP.
@param host,uuid,secret.
@return Promise<Bool>.
*/
public func start(host: String, uuid: String, secret: String)  -> Promise<Bool> {
    return runtime.start(host, uuid: uuid, secret: secret)
}

/**
Initialize the SDK and connect to EXP.
@param host,user,password,organization.
@return Promise<Bool>.
*/
public func start(host:String , user: String , password:String, organization:String) -> Promise<Bool> {
    return runtime.start(host, user: user, password: password, organization: organization)
}

/**
Initialize the SDK and connect to EXP.
@param options.
@return Promise<Bool>.
*/
public func start(options:[String:String]) -> Promise<Bool> {
    return runtime.start(options)
}

/**
    Get list of devices
    @param dictionary of search params
    @return Promise<Array<Device>>.
*/
public func findDevices(params:[String:AnyObject]) -> Promise<SearchResults<Device>>{
    return Promise { fulfill, reject in
     Alamofire.request(Router.findDevices(params))
            .responseCollection { (response: Response<SearchResults<Device>, NSError>) in
                switch response.result{
                case .Success(let data):
                    fulfill(data)
                case .Failure(let error):
                    return reject(error)
                }
        }
    }
}

/**
    Get Device by UUID
    @param uuid.
    @return Promise<Device>.
*/
public func getDevice(uuid:String) -> Promise<Device>{
    return Promise { fulfill, reject in
      Alamofire.request( Router.getDevice(uuid) )
            .responseObject { (response: Response<Device, NSError>) in
                switch response.result{
                case .Success(let data):
                    fulfill(data)
                case .Failure(let error):
                   return reject(error)
                }
        }
    }
}

/**
    Get Experience by UUID
    @param uuid.
    @return Promise<Experience>.
*/
public func getExperience(uuid:String) -> Promise<Experience>{
    return Promise { fulfill, reject in
       Alamofire.request(Router.getExperience(uuid) )
        .responseObject { (response: Response<Experience, NSError>) in
            switch response.result{
            case .Success(let data):
                fulfill(data)
            case .Failure(let error):
                return reject(error)
            }
        }
    }
}

/**
    Get list of Experiences
    @param dictionary of search params
    @return Promise<Array<Experience>>.
*/
public func findExperiences(params:[String:AnyObject]) -> Promise<SearchResults<Experience>>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.findExperiences(params))
            .responseCollection { (response: Response<SearchResults<Experience>, NSError>) in
                switch response.result{
                case .Success(let data):
                    fulfill(data)
                case .Failure(let error):
                    return reject(error)
                }
        }
    }
}

/**
    Get Location By UUID
    @param uuid.
    @return Promise<Location>.
*/
public func getLocation(uuid:String) -> Promise<Location>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.getLocation(uuid) )
            .responseObject { (response: Response<Location, NSError>) in
                switch response.result{
                case .Success(let data):
                    fulfill(data)
                case .Failure(let error):
                    return reject(error)
                }
        }
    }
}

/**
    Get list of Location
    @param dictionary of search params
    @return Promise<Array<Experience>>.
*/
public func findLocations(params:[String:AnyObject]) -> Promise<SearchResults<Location>>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.findLocations(params))
            .responseCollection { (response: Response<SearchResults<Location>, NSError>) in
                switch response.result{
                case .Success(let data):
                    fulfill(data)
                case .Failure(let error):
                    return reject(error)
                }
        }
    }
}


/**
Get Content Node By UUID
@param uuid.
@return Promise<ContentNode>.
*/
public func getContentNode(uuid:String) -> Promise<ContentNode>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.getContentNode(uuid) )
            .responseObject { (response: Response<ContentNode, NSError>) in
                switch response.result{
                case .Success(let data):
                    fulfill(data)
                case .Failure(let error):
                    return reject(error)
                }
        }
    }
}


/**
Find Data with params
@param [String:AnyObject].
@return Promise<SearchResults<Data>>.
*/
public func findData(params:[String:AnyObject]) -> Promise<SearchResults<Data>>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.findData(params))
            .responseCollection { (response: Response<SearchResults<Data>, NSError>) in
                switch response.result{
                case .Success(let data):
                    fulfill(data)
                case .Failure(let error):
                    return reject(error)
                }
        }
    }
}


/**
Get Data by Group and Key
@param uuid.
@return Promise<Data>.
*/
public func getData(group: String,  key: String) -> Promise<Data>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.getData(group, key))
            .responseObject { (response: Response<Data, NSError>) in
                switch response.result{
                case .Success(let data):
                    fulfill(data)
                case .Failure(let error):
                    return reject(error)
                }
        }
    }
}


/**
Login EXP system
@param user,password,organization.
@return Promise<Token>.
*/
func login(user:String,passwd:String,organization:String) ->Promise<Token>{
    return Promise { fulfill, reject in
        let req = Alamofire.request(Router.login(["username":user,"password":passwd,"org":organization]))
            .responseObject { (response: Response<Token, NSError>) in
                switch response.result{
                case .Success(let data):
                    fulfill(data)
                case .Failure(let error):
                    return reject(error)
                }
        }
        debugPrint(req)
    }
}

/**
Get Thing by UUID
@param uuid.
@return Promise<Thing>.
*/
public func getThing(uuid:String) -> Promise<Thing>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.getThing(uuid))
            .responseObject { (response: Response<Thing, NSError>) in
                switch response.result{
                case .Success(let data):
                    fulfill(data)
                case .Failure(let error):
                    return reject(error)
                }
        }
    }
}

/**
Get list of things
@param dictionary of search params
@return Promise<Array<Thing>>.
*/
public func findThings(params:[String:AnyObject]) -> Promise<SearchResults<Thing>>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.findThings(params))
            .responseCollection { (response: Response<SearchResults<Thing>, NSError>) in
                switch response.result{
                case .Success(let data):
                    fulfill(data)
                case .Failure(let error):
                    return reject(error)
                }
        }
    }
}



/**
Get Current Device
@return Promise<Any>
*/

public func getCurrentDevice() ->Promise<Any>{
    return socketManager.getCurrentDevice()
}

/**
Get Current Experience
@return Promise<Any>
*/

public func getCurrentExperience() ->Promise<Any>{
    return socketManager.getCurrentExperience()
}

/**
Connection Socket
@param name for connection(offline,line),callback
@return void
*/
public func connection(name:String,callback:String->Void){
    runtime.connection(name,  callback: { (resultListen) -> Void in
        callback(resultListen)
    })
}


/**
    Get Channel By Enum
    @param enum SCALA_SOCKET_CHANNELS.
    @return AnyObject (OrganizationChannel,LocationChannel,SystemChannel,ExperienceChannel).
*/
public func getChannel(typeChannel:SOCKET_CHANNELS) -> Any{
    return socketManager.getChannel(typeChannel)
}



