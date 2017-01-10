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

public enum BackendError: Error {
    case network(error: Error,message: Any)
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
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
    case getDynamicFeedData(String,[String:Any])
    case findFeeds([String: Any])
    case login([String: Any])
    case refreshToken()
    case broadcast([String: Any],String)
    case respond([String: Any])
    case getCurrentUser()
    case getToken([String: Any])
    //create 
    case createDevice([String:Any])
    case createData(String,String,[String:Any])
    case createExperience([String:Any])
    case createFeed([String:Any])
    case createLocation([String:Any])
    case createThing([String:Any])
    //save
    case saveDevice(String,[String:Any])
    case saveExperience(String,[String:Any])
    case saveFeed(String,[String:Any])
    case saveLocation(String,[String:Any])
    case saveThing(String,[String:Any])
    //delete
    case deleteDevice(String)
    case deleteData(String,String)
    case deleteExperience(String)
    case deleteFeed(String)
    case deleteLocation(String)
    case deleteThing(String)
    
    
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
        case .createDevice:
            return .post
        case .createData:
            return .put
        case .createExperience:
            return .post
        case .createFeed:
            return .post
        case .createLocation:
            return .post
        case .createThing:
            return .post
        case .saveDevice:
            return .patch
        case .saveExperience:
            return .patch
        case .saveFeed:
            return .patch
        case .saveLocation:
            return .patch
        case .saveThing:
            return .patch
        case .deleteDevice:
            return .delete
        case .deleteData:
            return .delete
        case .deleteExperience:
            return .delete
        case .deleteFeed:
            return .delete
        case .deleteLocation:
            return .delete
        case .deleteThing:
            return .delete
        case .getCurrentUser:
            return .get
        case .getToken:
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
            case .createDevice:
                return "/api/devices"
            case .createData(let group, let key,let document):
                return "/api/data/\(group)/\(key)"
            case .createExperience:
                return "/api/experiences"
            case .createFeed:
                return "/api/connectors/feeds"
            case .createLocation:
                return "/api/locations"
            case .createThing:
                return "/api/things"
            case .saveDevice(let uuid,_):
                return "/api/devices/\(uuid)"
            case .saveExperience(let uuid,_):
                return "/api/experiences/\(uuid)"
            case .saveFeed(let uuid,_):
                return "/api/connectors/feeds/\(uuid)"
            case .saveLocation(let uuid,_):
                return "/api/locations/\(uuid)"
            case .saveThing(let uuid,_):
                return "/api/things/\(uuid)"
            case .deleteDevice(let uuid):
                return "/api/devices/\(uuid)"
            case .deleteData(let group, let key):
                return "/api/data/\(group)/\(key)"
            case .deleteExperience(let uuid):
                return "/api/experiences/\(uuid)"
            case .deleteFeed(let uuid):
                return "/api/connectors/feeds/\(uuid)"
            case .deleteLocation(let uuid):
                return "/api/locations/\(uuid)"
            case .deleteThing(let uuid):
                return "/api/things/\(uuid)"
            case .getCurrentUser:
                return "/api/users/current"
            case .getToken:
                return "/api/auth/token"
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
        case .createDevice(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request createDevice: \(urlRequest)")
        case .createData(let group,let key,let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request createData: \(urlRequest)")
        case .createExperience(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request createExperience: \(urlRequest)")
        case .createFeed(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request createFeed: \(urlRequest)")
        case .createLocation(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request createLocation: \(urlRequest)")
        case .createThing(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request createThing: \(urlRequest)")
        case .saveDevice(_,let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request saveDevice: \(urlRequest)")
        case .saveExperience(_,let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request saveExperience: \(urlRequest)")
        case .saveFeed(_,let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request saveFeed: \(urlRequest)")
        case .saveLocation(_,let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request saveLocation: \(urlRequest)")
        case .saveThing(_,let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request saveThing: \(urlRequest)")
        case .getToken(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            expLogging("EXP Http Request getToken: \(urlRequest)")
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
public func start(_ options:[String:AnyObject]) -> Promise<Bool> {
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
    Create Device by document
    @return Promise<Device>.
 */
public func createDevice(_ document:[String:Any]) -> Promise<Device>{
    return Promise { fulfill, reject in
        Alamofire.request( Router.createDevice(document)).validate()
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
    Delete Device by uuid
    @param uuid
    @return Promise<Void>
 */
public func deleteDevice(_ uuid:String) -> Promise<Void>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.deleteDevice(uuid)).validate()
            .responseJSON { response in
                switch response.result{
                    case .success(let data):
                        fulfill()
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
 Create Experience by document
 @param document
 @return Promise<Experience>
 */
public func createExperience(_ document:[String:Any]) -> Promise<Experience>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.createExperience(document)).validate()
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
 Delete Experience by uuid
 @param uuid
 @return Promise<Void>
 */
public func deleteExperience(_ uuid:String) -> Promise<Void>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.deleteExperience(uuid)).validate()
            .responseJSON { response in
                switch response.result{
                case .success(let data):
                    fulfill()
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
 Create Location by document
 @param document
 @return Promise<Location>
 */
public func createLocation(_ document:[String:Any]) -> Promise<Location>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.createLocation(document)).validate()
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
 Delete Location by uuid
 @param uuid
 @return Promise<Void>
 */
public func deleteLocation(_ uuid:String) -> Promise<Void>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.deleteLocation(uuid)).validate()
            .responseJSON { response in
                switch response.result{
                case .success(let data):
                    fulfill()
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
public func getData(_ group: String,key: String) -> Promise<Data>{
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
 Create Data by document
 @param group,key,document
 @return Promise<Data>.
 */
public func createData(_ group: String,key: String,document: [String:Any]) -> Promise<Data>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.createData(group, key, document)).validate()
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
 Delete Data by uuid
 @param uuid
 @return Promise<Void>
 */
public func deleteData(_ group:String,key:String) -> Promise<Void>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.deleteData(group, key)).validate()
            .responseJSON { response in
                switch response.result{
                case .success(let data):
                    fulfill()
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
 Create Feed by document
 @param document
 @return Promise<Feed>
 */
public func createFeed(_ document:[String:Any]) -> Promise<Feed>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.createFeed(document)).validate()
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
 Delete Feed by uuid
 @param uuid
 @return Promise<Void>
 */
public func deleteFeed(_ uuid:String) -> Promise<Void>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.deleteFeed(uuid)).validate()
            .responseJSON { response in
                switch response.result{
                case .success(let data):
                    fulfill()
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
func login(_ options:[String:Any?]) ->Promise<Auth>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.login(options)).validate()
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
 Create Thing by document
 @param document
 @return Promise<Thing>
 */
public func createThing(_ document:[String:Any]) -> Promise<Thing>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.createThing(document)).validate()
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
 Delete Thing by uuid
 @param uuid
 @return Promise<Void>
 */
public func deleteThing(_ uuid:String) -> Promise<Void>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.deleteThing(uuid)).validate()
            .responseJSON { response in
                switch response.result{
                case .success(let data):
                    fulfill()
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
 Get Current User
 @param params.
 @return Promise<User>.
 */
public func getCurrentUser() -> Promise<User>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.getCurrentUser()).validate()
            .responseObject { (response: DataResponse<User>) in
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
 Get Current User
 @param params.
 @return Promise<User>.
 */
public func getToken(_ options:[String:AnyObject]) -> Promise<Auth>{
    return Promise { fulfill, reject in
        Alamofire.request(Router.getToken(options)).validate()
            .responseObject { (response: DataResponse<Auth>) in
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
 Get Current User
 @param params.
 @return Promise<User>.
 */
public func getUser(_ host:String, token:String) -> Promise<User>{
    expLogging("EXP GET USER  : \(token)")
    tokenSDK = token
    refreshAuthToken(token)
    if let callBack = authConnection[Config.UPDATE]{
        callBack(Config.UPDATE)
    }
    return Promise { fulfill, reject in
        Alamofire.request(Router.getCurrentUser()).validate()
            .responseObject { (response: DataResponse<User>) in
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
 Refresh Auth Token Recursive with Timeout
 */
private func refreshAuthToken(_ expirationToken:String){
    after(interval: getTimeout(Double(expirationToken)!)).then{ result -> Void in
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
 Get Time Out
 */
private func getTimeout(_ expiration:Double) -> TimeInterval{
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

