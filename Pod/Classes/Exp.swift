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


var hostUrl: String = ""
var tokenSDK: String = ""
var hostSocket: String = ""
var auth:Auth?
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
    case getContent(String)
    case findContent([String: AnyObject])
    case findData([String: AnyObject])
    case getData(String,String)
    case getThing(String)
    case findThings([String: AnyObject])
    case getFeed(String)
    case getFeedData(String)
    case findFeeds([String: AnyObject])
    case login([String: AnyObject])
    case refreshToken()
    case broadcast([String: AnyObject],String)
    case respond([String: AnyObject])
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
        case .getContent:
            return .GET
        case .findContent:
            return .GET
        case .findData:
            return .GET
        case .getData:
            return .GET
        case .getThing:
            return .GET
        case .findThings:
            return .GET
        case .getFeed:
            return .GET
        case .getFeedData:
            return .GET
        case .findFeeds:
            return .GET
        case .login:
            return .POST
        case .refreshToken:
            return .POST
        case .broadcast:
            return .POST
        case .respond:
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
            case .getContent(let uuid):
                return "/api/content/\(uuid)/children"
            case .findContent:
                return "/api/content"
            case .findData:
                return "/api/data"
            case .getData(let group, let key):
                return "/api/data/\(group)/\(key)"
            case .getThing(let uuid):
                return "/api/things/\(uuid)"
            case .findThings:
                return "/api/things"
            case .getFeed(let uuid):
                return "/api/connectors/feeds/\(uuid)"
            case .getFeedData(let uuid):
                return "/api/connectors/feeds/\(uuid)/data"
            case .findFeeds:
                return "/api/connectors/feeds"
            case .login:
                return "/api/auth/login"
            case .refreshToken:
                return "/api/auth/token"
            case .broadcast:
                return "/api/networks/current/broadcasts"
            case .respond:
                return "/api/networks/current/responses"

        }
        
    }
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: hostUrl)!
        var mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        expLogging(mutableURLRequest.URLString)
        mutableURLRequest.HTTPMethod = method.rawValue
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("Bearer \(tokenSDK)", forHTTPHeaderField: "Authorization")
        switch self {
            case .findDevices(let parameters):
                let reqFindDevices = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
                expLogging("EXP Http Request findDevices: \(reqFindDevices)")
                return reqFindDevices
            case .findExperiences(let parameters):
                let reqFindExperiences = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
                expLogging("EXP Http Request findExperiences: \(reqFindExperiences)")
                return reqFindExperiences
            case .findLocations(let parameters):
                let reqFindLocations = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
                expLogging("EXP Http Request findLocations: \(reqFindLocations)")
                return reqFindLocations
            case .findData(let parameters):
                let reqFindData = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
                expLogging("EXP Http Request findData: \(reqFindData)")
                return reqFindData
            case .findThings(let parameters):
                let reqFindThings = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
                expLogging("EXP Htpp Request findThings: \(reqFindThings)")
                return reqFindThings
            case .findContent(let parameters):
                let reqFindContentNodes = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
                expLogging("EXP Http Request findContentNodes: \(reqFindContentNodes)")
                return reqFindContentNodes
            case .findFeeds(let parameters):
                let reqFindFeeds = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
                expLogging("EXP Http Request findFeeds: \(reqFindFeeds)")
                return reqFindFeeds
            case .login(let parameters):
                let reqLogin = Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
                expLogging("EXP Http Request login: \(reqLogin)")
                return reqLogin
            case .broadcast(let parameters,let timeout):
                expLogging("EXP Http Request broadcast parameters: \(parameters)")
                let reqBroadcast = Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
                reqBroadcast.URL = NSURL(string: reqBroadcast.URLString+"?timeout=\(timeout)")
                return reqBroadcast
            case .respond(let parameters):
                let reqRespond = Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
                expLogging("EXP Http Request Respond: \(reqRespond)")
                return reqRespond
            default:
                expLogging("EXP Http Request : \(mutableURLRequest)")
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
    @return Promise<SearchResults<Device>>.
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
    @return Promise<SearchResults<Experience>>.
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
    @return Promise<SearchResults<Location>>.
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
public func getContentNode(uuid:String) -> Promise<Content>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.getContent(uuid) )
            .responseObject { (response: Response<Content, NSError>) in
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
 Get list of content node
 @param dictionary of search params
 @return Promise<SearchResults<ContentNode>>.
 */
public func findContent(params:[String:AnyObject]) -> Promise<SearchResults<Content>>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.findContent(params))
            .responseCollection { (response: Response<SearchResults<Content>, NSError>) in
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
 Get Feed By UUID
 @param uuid.
 @return Promise<Feed>.
 */
public func getFeed(uuid:String) -> Promise<Feed>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.getFeed(uuid) )
            .responseObject { (response: Response<Feed, NSError>) in
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
 Get list of Feeds
 @param dictionary of search params
 @return Promise<SearchResults<Feed>>.
 */
public func findFeeds(params:[String:AnyObject]) -> Promise<SearchResults<Feed>>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.findFeeds(params))
            .responseCollection { (response: Response<SearchResults<Feed>, NSError>) in
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
 @param options.
 @return Promise<Auth>.
 */
func login(options:[String:String]) ->Promise<Auth>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.login(options))
            .responseObject { (response: Response<Auth, NSError>) in
                switch response.result{
                case .Success(let data):
                    fulfill(data)
                    expLogging("EXP login response : \(data.document)")
                    auth = data
                    setTokenSDK(data)
                    refreshAuthToken(data)
                case .Failure(let error):
                    // try again in 5 seconds
                    after(NSTimeInterval(runtime.timeout)).then{ result -> Void in
                        runtime.start(runtime.optionsRuntime)
                    }
                    return reject(error)
                }
        }
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
 Refresh Token
 @param options.
 @return Promise<Auth>.
 */
public func refreshToken() -> Promise<Auth>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.refreshToken())
            .responseObject { (response: Response<Auth, NSError>) in
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
 Send Broadcast message
 @param timeout,params.
 @return Promise<Message>.
 */
public func broadCast(timeout:String,params:[String:AnyObject]) -> Promise<Message>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.broadcast(params,timeout))
            .responseObject { (response: Response<Message, NSError>) in
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
 Respond to broadcast message
 @param params.
 @return Promise<Message>.
 */
public func respond(params:[String:AnyObject]) -> Promise<Message>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.respond(params))
            .responseObject { (response: Response<Message, NSError>) in
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
 Get Channel By String
 @param String nameChannel.
 @return CommonChannel
 */
public func getChannel(nameChannel:String,system:Bool,consumerApp:Bool) -> Channel{
    return socketManager.getChannel(nameChannel,system: system,consumerApp: consumerApp)
}

/**
 Stop Connection EXP
*/
public func stop(){
    runtime.stop()
}


/**
 Refresh Auth Token Recursive with Timeout
*/
private func refreshAuthToken(result:Auth){
    after(getTimeout(result)).then{ result -> Void in
        refreshToken().then{ result -> Void in
            setTokenSDK(result)
            expLogging("EXP refreshAuthToken: \(result.document)")
            socketManager.refreshConnection()
            refreshAuthToken(result)
        }
    }

}

/**
 Get Time Out
 */
private func getTimeout(data:Auth) -> NSTimeInterval{
    let expiration = data.get("expiration") as! Double
    let startDate = NSDate(timeIntervalSince1970: expiration/1000)
    let timeout = startDate.timeIntervalSinceDate(NSDate())
    return NSTimeInterval(Int64(timeout))
}

/**
 Set Token SDK
 */
private func setTokenSDK(data:Auth){
    tokenSDK = data.get("token") as! String
}

/**
 If Socket is connected
 */
public func isConnected()->Bool{
    return runtime.isConnected()
}

