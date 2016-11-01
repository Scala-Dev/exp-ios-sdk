//
//  Exp.swift
//  Pods
//
//  Created by Cesar on 9/4/15.
//
//

import Foundation
import SocketIO
import Alamofire
import PromiseKit
import JWT


var hostUrl: String = ""
var tokenSDK: String = ""
var hostSocket: String = ""
public var auth:Auth?
var socketManager = SocketManager()
var runtime = Runtime()
public typealias CallBackTypeConnection = (String) -> Void
var authConnection = [String: CallBackTypeConnection]()


public enum SOCKET_CHANNELS: String {
    case SYSTEM = "system"
    case ORGANIZATION = "organization"
    case LOCATION = "location"
    case EXPERIENCE = "experience"
}



enum Router: URLRequestConvertible {
    static let baseURLString = hostUrl
    case findDevices([String: Any])
    case getDevice(String)
    case getExperience(String)
    case findExperiences([String: Any])
    case getLocation(String)
    case findLocations([String: Any])
    case getContent(String)
    case findContent([String: Any])
    case getContentNode(String)
    case findContentNodes([String: Any])
    case findData([String: Any])
    case getData(String,String)
    case getThing(String)
    case findThings([String: Any])
    case getFeed(String)
    case getFeedData(String)
    //todo fix param
    case getDynamicFeedData(String,[String:Any])
    case findFeeds([String: Any])
    case login([String: Any])
    case refreshToken()
    //todo fix param
    case broadcast([String: Any],String)
    case respond([String: Any])
    
    var method: HTTPMethod {
        switch self {
        case .findDevices:
            return .get
        case .getDevice:
            return .get
        case .getExperience:
            return .get
        case .findExperiences:
            return .get
        case .getLocation:
            return .get
        case .findLocations:
            return .get
        case .getContent:
            return .get
        case .getContentNode:
            return .get
        case .findContent:
            return .get
        case .findContentNodes:
            return .get
        case .findData:
            return .get
        case .getData:
            return .get
        case .getThing:
            return .get
        case .findThings:
            return .get
        case .getFeed:
            return .get
        case .getFeedData:
            return .get
        case .getDynamicFeedData:
            return .get
        case .findFeeds:
            return .get
        case .login:
            return .post
        case .refreshToken:
            return .post
        case .broadcast:
            return .post
        case .respond:
            return .post
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
            case .getContentNode(let uuid):
                return "/api/content/\(uuid)/children"
            case .findContent:
                return "/api/content"
            case .findContentNodes:
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
            case .getDynamicFeedData:
                return "/api/connectors/feeds/"
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
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(tokenSDK)", forHTTPHeaderField: "Authorization")
        
        switch self {
        case .findDevices(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request findDevices: \(urlRequest)")
        case .findExperiences(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request findExperiences: \(urlRequest)")
        case .findLocations(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request findLocations: \(urlRequest)")
        case .findData(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request findData: \(urlRequest)")
        case .findThings(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request findThings: \(urlRequest)")
        case .findContent(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request findContent: \(urlRequest)")
        case .findContentNodes(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request findContentNodes: \(urlRequest)")
        case .findFeeds(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request findFeeds: \(urlRequest)")
        case .login(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request login: \(urlRequest)")
        case .broadcast(let parameters,let timeout):
            urlRequest.url?.appendingPathComponent("?timeout=\(timeout)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request broadcast: \(urlRequest)")
        case .respond(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request respond: \(urlRequest)")
        case .getDynamicFeedData(let uuid,let parameters):
            urlRequest.url?.appendingPathComponent("\(uuid)/data")
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request getDynamicFeedData: \(urlRequest)")
        default:
            break
        }
        
        return urlRequest
    }
}


/**
Initialize the SDK and connect to EXP.
@param host,uuid,secret.
@return Promise<Bool>.
*/
public func start(_ host: String, uuid: String, secret: String)  -> Promise<Bool> {
    return runtime.start(host, uuid: uuid, secret: secret)
}

/**
Initialize the SDK and connect to EXP.
@param host,user,password,organization.
@return Promise<Bool>.
*/
public func start(_ host:String , user: String , password:String, organization:String) -> Promise<Bool> {
    return runtime.start(host, user: user, password: password, organization: organization)
}

/**
Initialize the SDK and connect to EXP.
@param options.
@return Promise<Bool>.
*/
public func start(_ options:[String:String]) -> Promise<Bool> {
    return runtime.start(options)
}

/**
    Get list of devices
    @param dictionary of search params
    @return Promise<SearchResults<Device>>.
*/
public func findDevices(_ params:[String:Any]) -> Promise<SearchResults<Device>>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.findDevices(params)).validate()
            .responseCollection { (response: DataResponse<SearchResults<Device>>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
public func getDevice(_ uuid:String) -> Promise<Device>{
    return Promise { fulfill, reject in
        Alamofire.request( Router.getDevice(uuid)).validate()
            .responseObject { (response: DataResponse<Device>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
public func getExperience(_ uuid:String) -> Promise<Experience>{
    return Promise { fulfill, reject in
       Alamofire.request(Router.getExperience(uuid)).validate()
        .responseObject { (response: DataResponse<Experience>) in
            switch response.result{
            case .success(let data):
                fulfill(data)
            case .failure(let error):
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
public func findExperiences(_ params:[String:Any]) -> Promise<SearchResults<Experience>>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.findExperiences(params)).validate()
            .responseCollection { (response: DataResponse<SearchResults<Experience>>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
public func getLocation(_ uuid:String) -> Promise<Location>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.getLocation(uuid)).validate()
            .responseObject { (response: DataResponse<Location>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
public func findLocations(_ params:[String:Any]) -> Promise<SearchResults<Location>>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.findLocations(params)).validate()
            .responseCollection { (response: DataResponse<SearchResults<Location>>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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

@available(*, deprecated: 1.0.0, message: "use getContent(uuid)") public func getContentNode(_ uuid:String) -> Promise<ContentNode>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.getContentNode(uuid)).validate()
            .responseObject { (response: DataResponse<ContentNode>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
public func getContent(_ uuid:String) -> Promise<Content>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.getContent(uuid)).validate()
            .responseObject { (response: DataResponse<Content>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
                    return reject(error)
                }
        }
    }
}

/**
 Get list of content node
 @param dictionary of search params
 @return Promise<SearchResults<Content>>.
 */
public func findContent(_ params:[String:Any]) -> Promise<SearchResults<Content>>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.findContent(params)).validate()
            .responseCollection { (response: DataResponse<SearchResults<Content>>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
@available(*, deprecated: 1.0.0, message: "use findContent(options)")public func findContentNodes(_ params:[String:AnyObject]) -> Promise<SearchResults<ContentNode>>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.findContentNodes(params)).validate()
            .responseCollection { (response: DataResponse<SearchResults<ContentNode>>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
public func findData(_ params:[String:Any]) -> Promise<SearchResults<Data>>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.findData(params)).validate()
            .responseCollection { (response: DataResponse<SearchResults<Data>>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
public func getData(_ group: String,  key: String) -> Promise<Data>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.getData(group, key)).validate()
            .responseObject { (response: DataResponse<Data>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
public func getFeed(_ uuid:String) -> Promise<Feed>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.getFeed(uuid)).validate()
            .responseObject { (response: DataResponse<Feed>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
public func findFeeds(_ params:[String:Any]) -> Promise<SearchResults<Feed>>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.findFeeds(params)).validate()
            .responseCollection { (response: DataResponse<SearchResults<Feed>>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
func login(_ options:[String:String]) ->Promise<Auth>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.login(options as [String : AnyObject])).validate()
            .responseObject { (response: DataResponse<Auth>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                    expLogging("EXP login response : \(data.document)")
                    auth = data
                    setTokenSDK(data)
                    refreshAuthToken(data)
                    if let callBack = authConnection[Config.UPDATE]{
                        callBack(Config.UPDATE)
                    }
                case .failure(let error):
                    if let callBack = authConnection[Config.ERROR]{
                        callBack(Config.ERROR)
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
public func getThing(_ uuid:String) -> Promise<Thing>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.getThing(uuid)).validate()
            .responseObject { (response: DataResponse<Thing>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
public func findThings(_ params:[String:Any]) -> Promise<SearchResults<Thing>>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.findThings(params)).validate()
            .responseCollection { (response: DataResponse<SearchResults<Thing>>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
            .responseObject { (response: DataResponse<Auth>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                    if let callBack = authConnection[Config.UPDATE]{
                        callBack(Config.UPDATE)
                    }
                case .failure(let error):
                    // try again in 5 seconds
                    after(interval: TimeInterval(runtime.timeout)).then{ result -> Void in
                        runtime.start(runtime.optionsRuntime)
                    }
                    if let callBack = authConnection[Config.ERROR]{
                        callBack(Config.ERROR)
                    }
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
public func broadCast(_ timeout:String,params:[String:Any]) -> Promise<Message>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.broadcast(params,timeout)).validate()
            .responseObject { (response: DataResponse<Message>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
public func respond(_ params:[String:Any]) -> Promise<Message>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.respond(params)).validate()
            .responseObject { (response: DataResponse<Message>) in
                switch response.result{
                case .success(let data):
                    fulfill(data)
                case .failure(let error):
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
public func connection(_ name:String,callback:@escaping (String)->Void){
    runtime.connection(name,  callback: { (resultListen) -> Void in
        callback(resultListen)
    })
}


/**
 Get Channel By String
 @param String nameChannel.
 @return CommonChannel
 */
public func getChannel(_ nameChannel:String,system:Bool,consumerApp:Bool) -> Channel{
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
private func refreshAuthToken(_ result:Auth){
    after(interval: getTimeout(result)).then{ result -> Void in
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
private func getTimeout(_ data:Auth) -> TimeInterval{
    let expiration = data.get("expiration") as! Double
    let startDate = Date(timeIntervalSince1970: expiration/1000)
    let timeout = startDate.timeIntervalSince(Date())
    return TimeInterval(Int64(timeout))
}

/**
 Set Token SDK
 */
private func setTokenSDK(_ data:Auth){
    tokenSDK = data.get("token") as! String
}

/**
 If Socket is connected
 */
public func isConnected()->Bool{
    return runtime.isConnected()
}



/**
 Auth connection callback
 @param name for connection(update,line),callback
 @return void
 */
public func on(_ name:String,callback:@escaping (String)->Void){
    authConnection.updateValue(callback, forKey: name)
}

