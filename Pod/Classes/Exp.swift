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
    case GetDevices([String: AnyObject])
    case GetDevice(String)
    var method: Alamofire.Method {
        switch self {
        case .GetDevices:
            return .GET
        case .GetDevice:
            return .GET
        }
    }
    
    var path: String {
        switch self {
            case .GetDevice(let uuid):
                return "/api/devices/\(uuid)"
        case .GetDevices:
            return "/api/devices"
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: hostUrl)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue

        mutableURLRequest.setValue("Bearer \(tokenSDK)", forHTTPHeaderField: "Authorization")
        switch self {
        case .GetDevices(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}


class Session {
    static let sharedInstance = Session()
    private var manager : Manager?
    
    func ApiManager()->Manager{
        if let m = self.manager{
            return m
        }else{
            let serverTrustPolicies: [String: ServerTrustPolicy] = ["api-develop.exp.scala.com": .DisableEvaluation]
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let tempmanager = Alamofire.Manager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
            self.manager = tempmanager
            return self.manager!
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
//public func findDevices(params:[String:AnyObject]) -> Promise<Device>{
//    return Promise { fulfill, reject in
//        let request = Alamofire.request(.GET, hostUrl + "/api/devices", parameters: params )
//        request.responseCollection { (request, response, devices: Device, error) in
//            
//            var statusCode = response?.statusCode
//            if(error != nil) {
//                return reject(error!)
//            }
//            if(statusCode < 200 || statusCode > 299) {
//                return reject(NSError(domain: hostUrl + "/api/devices", code: statusCode!, userInfo: [:]))
//            }
//            fulfill(devices!)
//        }
//    }
//}

public func findDevices(params:[String:AnyObject]) -> Promise<[Device]>{
    return Promise { fulfill, reject in
      let req = Session.sharedInstance.ApiManager().request(Router.GetDevices(params))
            .responseCollection { (response: Response<[Device], NSError>) in
//                debugPrint(response)
                switch response.result{
                case .Success(let data):
//                    debugPrint(response.result)
                    fulfill(data)
                case .Failure(let error):
//                    debugPrint(response.result)
                    return reject(error)
                }
        }
        debugPrint(req)
    }
}



/**
Get list of devices
@param dictionary of search params
@return Promise<Array<Device>>.
*/
//@availability(*, deprecated=0.0.1, message="use findDevices() instead")
//public func getDevices(params:[String:AnyObject]) -> Promise<SearchResults<Device>>{
//    return findDevices(params)
//}


/**
    Get Device by UUID
    @param uuid.
    @return Promise<Device>.
*/
public func getDevice(uuid:String) -> Promise<Device>{
    return Promise { fulfill, reject in
//        let serverTrustPolicies: [String: ServerTrustPolicy] = [
//            "api-develop.exp.scala.com": .DisableEvaluation,
//            "*.exp.scala.com": .DisableEvaluation
//        ]
//        
//        manager = Manager(
//            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
//            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
//        )
//        let headers = ["Authorization": "Bearer " + tokenSDK]
        debugPrint(tokenSDK)
//        Alamofire.request(.GET, hostUrl + "/api/devices/"+uuid, headers: headers )
//        let headers = [
//            "Authorization": tokenSDK,
//        ]
        Session.sharedInstance.ApiManager().request( Router.GetDevice(uuid) )
            .responseObject { (response: Response<Device, NSError>) in
                debugPrint(response)
                switch response.result{
                case .Success(let data):
                    debugPrint(response.result)
                case .Failure(let error):
                    debugPrint(response.result)
                }
        }

//        let request = Alamofire.request(.GET, hostUrl + "/api/devices/" + uuid )
//        request.responseObject { (request, response, device: Device?, error) in
//            var statusCode = response?.statusCode
//            if(error != nil) {
//                return reject(error!)
//            }
//            if(statusCode < 200 || statusCode > 299) {
//                return reject(NSError(domain: hostUrl + "/api/devices", code: statusCode!, userInfo: [:]))
//            }
//            fulfill(device!)
//        }
    }
}

/**
    Get Experience by UUID
    @param uuid.
    @return Promise<Experience>.
*/
public func getExperience(uuid:String) -> Promise<Experience>{
    return Promise { fulfill, reject in
//        let request = Alamofire.request(.GET, hostUrl + "/api/experiences/" + uuid )
//        request.responseObject { (request, response, experience: Experience?, error) in
//            var statusCode = response?.statusCode
//            if(error != nil) {
//                return reject(error!)
//            }
//            if(statusCode < 200 || statusCode > 299) {
//                return reject(NSError(domain: hostUrl + "/api/experiences", code: statusCode!, userInfo: [:]))
//            }
//            fulfill(experience!)
//        }
    }
}

/**
    Get list of Experiences
    @param dictionary of search params
    @return Promise<Array<Experience>>.
*/
public func findExperiences(params:[String:AnyObject]) -> Promise<SearchResults<Experience>>{
    return Promise { fulfill, reject in
//        let request = Alamofire.request(.GET, hostUrl + "/api/experiences", parameters: params )
//        request.responseCollection { (request, response, experiences: SearchResults<Experience>?, error) in
//            var statusCode = response?.statusCode
//            if(error != nil) {
//                return reject(error!)
//            }
//            if(statusCode < 200 || statusCode > 299) {
//                return reject(NSError(domain: hostUrl + "/api/experiences", code: statusCode!, userInfo: [:]))
//            }
//            fulfill(experiences!)
//        }
    }
}

/**
Get list of Experiences
@param dictionary of search params
@return Promise<Array<Experience>>.
*/
//@availability(*, deprecated=0.0.1, message="use findExperiences() instead")
//public func getExperiences(params:[String:AnyObject]) -> Promise<SearchResults<Experience>>{
//    return findExperiences(params)
//}


/**
    Get Location By UUID
    @param uuid.
    @return Promise<Location>.
*/
public func getLocation(uuid:String) -> Promise<Location>{
    return Promise { fulfill, reject in
//        let request = Alamofire.request(.GET, hostUrl + "/api/locations/" + uuid )
//        request.responseObject { (request, response, location: Location?, error) in
//            var statusCode = response?.statusCode
//            if(error != nil) {
//                return reject(error!)
//            }
//            if(statusCode < 200 || statusCode > 299) {
//                return reject(NSError(domain: hostUrl + "/api/locations", code: statusCode!, userInfo: [:]))
//            }
//            fulfill(location!)
//        }
    }
}

/**
    Get list of Location
    @param dictionary of search params
    @return Promise<Array<Experience>>.
*/
public func findLocations(params:[String:AnyObject]) -> Promise<SearchResults<Location>>{
    return Promise { fulfill, reject in
//        let request = Alamofire.request(.GET, hostUrl + "/api/locations", parameters: params)
//        request.responseCollection { (request, response, locations: SearchResults<Location>?, error) in
//            var statusCode = response?.statusCode
//            if(error != nil) {
//                return reject(error!)
//            }
//            if(statusCode < 200 || statusCode > 299) {
//                return reject(NSError(domain: hostUrl + "/api/locations", code: statusCode!, userInfo: [:]))
//            }
//            fulfill(locations!)
//        }
    }
}

/**
Get list of Location
    @param dictionary of search params
@return Promise<Array<Experience>>.
*/
//@availability(*, deprecated=0.0.1, message="use findLocations() instead")
//public func getLocations(params:[String:AnyObject]) -> Promise<SearchResults<Location>>{
//    return findLocations(params)
//}




/**
Get Content Node By UUID
@param uuid.
@return Promise<ContentNode>.
*/
public func getContentNode(uuid:String) -> Promise<ContentNode>{
    return Promise { fulfill, reject in
//        let request = Alamofire.request(.GET, hostUrl + "/api/content/" + uuid + "/children")
//        request.responseObject { (request, response, content: ContentNode?, error) in
//            var statusCode = response?.statusCode
//            if(error != nil) {
//                return reject(error!)
//            }
//            if(statusCode < 200 || statusCode > 299) {
//                return reject(NSError(domain: hostUrl + "/api/content", code: statusCode!, userInfo: [:]))
//            }
//            fulfill(content!)
//        }
    }
}


/**
Find Data with params
@param [String:AnyObject].
@return Promise<SearchResults<Data>>.
*/
public func findData(params:[String:AnyObject]) -> Promise<SearchResults<Data>>{
    
    return Promise { fulfill, reject in
        _ = Alamofire.request(.GET, hostUrl + "/api/data", parameters: params )
//        request.responseCollection { (request, response, data: SearchResults<Data>?, error) in
//            var statusCode = response?.statusCode
//            if(error != nil) {
//                return reject(error!)
//            }
//            if(statusCode < 200 || statusCode > 299) {
//                return reject(NSError(domain: hostUrl + "/api/data", code: statusCode!, userInfo: [:]))
//            }
//            fulfill(data!)
//        }
    }
}

/**
Get Data by Group and Key
@param uuid.
@return Promise<Data>.
*/
public func getData(group: String,  key: String) -> Promise<Data>{
    return Promise { fulfill, reject in
//        let request = Alamofire.request(.GET, hostUrl + "/api/data/" + group.encodeURIComponent()! + "/" + key.encodeURIComponent()!)
//        request.responseObject { (request, response, data: Data?, error) in
//            var statusCode = response?.statusCode
//            if(error != nil) {
//                return reject(error!)
//            }
//            if(statusCode < 200 || statusCode > 299) {
//                return reject(NSError(domain: hostUrl + "/api/data", code: statusCode!, userInfo: [:]))
//            }
//            fulfill(data!)
//        }
    }
}


/**
Login EXP system
@param user,password,organization.
@return Promise<Token>.
*/
func login(user:String,passwd:String,organization:String) ->Promise<Token>{
    
    return Promise { fulfill, reject in
//        let request = Alamofire.request(.POST, hostUrl + "/api/auth/login",parameters:["username":user,"password":passwd,"org":organization],encoding: .JSON)
//        request.responseObject { (request, response, token: Token?, error) in
//            var statusCode = response?.statusCode
//            if(error != nil) {
//                return reject(error!)
//            }
//            if(statusCode < 200 || statusCode > 299) {
//                return reject(NSError(domain: hostUrl + "/auth/login", code: statusCode!, userInfo: [:]))
//            }
//            fulfill(token!)
//        }
    }
}

/**
Get Thing by UUID
@param uuid.
@return Promise<Thing>.
*/
public func getThing(uuid:String) -> Promise<Thing>{
    return Promise { fulfill, reject in
//        let request = Alamofire.request(.GET, hostUrl + "/api/things/" + uuid )
//        request.responseObject { (request, response, thing: Thing?, error) in
//            var statusCode = response?.statusCode
//            if(error != nil) {
//                return reject(error!)
//            }
//            if(statusCode < 200 || statusCode > 299) {
//                return reject(NSError(domain: hostUrl + "/api/things", code: statusCode!, userInfo: [:]))
//            }
//            fulfill(thing!)
//        }
    }
}

/**
Get list of things
@param dictionary of search params
@return Promise<Array<Thing>>.
*/
public func findThings(params:[String:AnyObject]) -> Promise<SearchResults<Thing>>{
    return Promise { fulfill, reject in
//        let request = Alamofire.request(.GET, hostUrl + "/api/things", parameters: params )
//        request.responseCollection { (request, response, things: SearchResults<Thing>?, error) in
//            
//            var statusCode = response?.statusCode
//            if(error != nil) {
//                return reject(error!)
//            }
//            if(statusCode < 200 || statusCode > 299) {
//                return reject(NSError(domain: hostUrl + "/api/things", code: statusCode!, userInfo: [:]))
//            }
//            fulfill(things!)
//        }
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



