//
//  Scala.swift
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
var socketManager = SocketManager()
public var runtime = Runtime()


public enum SOCKET_CHANNELS: String {
    case SYSTEM = "system"
    case ORGANIZATION = "organization"
    case LOCATION = "location"
    case EXPERIENCE = "experience"
}









/**
    Get list of devices
    @param limit,skip,sort.
    @return Promise<Array<Device>>.
*/
public func getDevices(limit:Int, skip:Int, sort:String) -> Promise<Array<Device>>{
        return Promise { fulfill, reject in
                let request = Alamofire.request(.GET, hostUrl + "/api/devices?" + "limit=" + String(limit) + "&skip=" + String(skip) + "&sort=" + sort )
                   request.responseCollection { (request, response, devices: [Device]?, error) in
                    
                    var statusCode = response?.statusCode
                        if(error != nil) {
                            return reject(error!)
                        }
                        if(statusCode < 200 || statusCode > 299) {
                            return reject(NSError(domain: hostUrl + "/api/devices", code: statusCode!, userInfo: [:]))
                        }
                        fulfill(devices!)
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
        let request = Alamofire.request(.GET, hostUrl + "/api/devices/" + uuid )
        request.responseObject { (request, response, device: Device?, error) in
            var statusCode = response?.statusCode
            if(error != nil) {
                return reject(error!)
            }
            if(statusCode < 200 || statusCode > 299) {
                return reject(NSError(domain: hostUrl + "/api/devices", code: statusCode!, userInfo: [:]))
            }
            fulfill(device!)
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
        let request = Alamofire.request(.GET, hostUrl + "/api/experiences/" + uuid )
        request.responseObject { (request, response, experience: Experience?, error) in
            var statusCode = response?.statusCode
            if(error != nil) {
                return reject(error!)
            }
            if(statusCode < 200 || statusCode > 299) {
                return reject(NSError(domain: hostUrl + "/api/experiences", code: statusCode!, userInfo: [:]))
            }
            fulfill(experience!)
        }
    }
}

/**
    Get list of Experiences
    @param limit,skip,sort.
    @return Promise<Array<Experience>>.
*/
public func getExperiences(limit:Int, skip:Int, sort:String) -> Promise<Array<Experience>>{
    return Promise { fulfill, reject in
        let request = Alamofire.request(.GET, hostUrl + "/api/experiences?" + "limit=" + String(limit) + "&skip=" + String(skip) + "&sort=" + sort )
        request.responseCollection { (request, response, experiences: [Experience]?, error) in
            var statusCode = response?.statusCode
            if(error != nil) {
                return reject(error!)
            }
            if(statusCode < 200 || statusCode > 299) {
                return reject(NSError(domain: hostUrl + "/api/experiences", code: statusCode!, userInfo: [:]))
            }
            fulfill(experiences!)
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
        let request = Alamofire.request(.GET, hostUrl + "/api/locations/" + uuid )
        request.responseObject { (request, response, location: Location?, error) in
            var statusCode = response?.statusCode
            if(error != nil) {
                return reject(error!)
            }
            if(statusCode < 200 || statusCode > 299) {
                return reject(NSError(domain: hostUrl + "/api/locations", code: statusCode!, userInfo: [:]))
            }
            fulfill(location!)
        }
    }
}

/**
    Get list of Location
    @param limit,skip,sort.
    @return Promise<Array<Experience>>.
*/
public func getLocations(limit:Int, skip:Int, sort:String) -> Promise<Array<Location>>{
    return Promise { fulfill, reject in
        let request = Alamofire.request(.GET, hostUrl + "/api/locations?" + "limit=" + String(limit) + "&skip=" + String(skip) + "&sort=" + sort )
        request.responseCollection { (request, response, locations: [Location]?, error) in
            var statusCode = response?.statusCode
            if(error != nil) {
                return reject(error!)
            }
            if(statusCode < 200 || statusCode > 299) {
                return reject(NSError(domain: hostUrl + "/api/locations", code: statusCode!, userInfo: [:]))
            }
            fulfill(locations!)
        }
    }
}

/**
    Get list of Zones
    @param limit,skip,sort.
    @return Promise<Array<Zone>>.
*/
public func getZones(limit:Int, skip:Int, sort:String) -> Promise<Array<Zone>>{
    return Promise { fulfill, reject in
        let request = Alamofire.request(.GET, hostUrl + "/api/zones?" + "limit=" + String(limit) + "&skip=" + String(skip) + "&sort=" + sort )
        request.responseCollection { (request, response, zones: [Zone]?, error) in
            var statusCode = response?.statusCode
            if(error != nil) {
                return reject(error!)
            }
            if(statusCode < 200 || statusCode > 299) {
                return reject(NSError(domain: hostUrl + "/api/zones", code: statusCode!, userInfo: [:]))
            }
            fulfill(zones!)
        }
    }
}

/**
    Get Zone By UUID
    @param uuid.
    @return Promise<Zone>.
*/
public func getZone(uuid:String) -> Promise<Zone>{
    return Promise { fulfill, reject in
        let request = Alamofire.request(.GET, hostUrl + "/api/zones/" + uuid )
        request.responseObject { (request, response, zone: Zone?, error) in
            var statusCode = response?.statusCode
            if(error != nil) {
                return reject(error!)
            }
            if(statusCode < 200 || statusCode > 299) {
                return reject(NSError(domain: hostUrl + "/api/zones", code: statusCode!, userInfo: [:]))
            }
            fulfill(zone!)
        }
    }
}


/**
Get Zone By UUID
@param uuid.
@return Promise<Zone>.
*/
public func getContentNode(uuid:String) -> Promise<ContentNode>{
    return Promise { fulfill, reject in
        let request = Alamofire.request(.GET, hostUrl + "/api/content/" + uuid + "/children")
        request.responseObject { (request, response, content: ContentNode?, error) in
            var statusCode = response?.statusCode
            if(error != nil) {
                return reject(error!)
            }
            if(statusCode < 200 || statusCode > 299) {
                return reject(NSError(domain: hostUrl + "/api/content", code: statusCode!, userInfo: [:]))
            }
            fulfill(content!)
        }
    }
}


/**
Login EXP system
@param user,password,organization.
@return Promise<Token>.
*/
public func login(user:String,passwd:String,organization:String) ->Promise<Token>{
    
    return Promise { fulfill, reject in
        let request = Alamofire.request(.POST, hostUrl + "/api/auth/login",parameters:["username":user,"password":passwd,"org":organization],encoding: .JSON)
        request.responseObject { (request, response, token: Token?, error) in
            var statusCode = response?.statusCode
            if(error != nil) {
                return reject(error!)
            }
            if(statusCode < 200 || statusCode > 299) {
                return reject(NSError(domain: hostUrl + "/auth/login", code: statusCode!, userInfo: [:]))
            }
            fulfill(token!)
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
    Get Channel By Enum
    @param enum SCALA_SOCKET_CHANNELS.
    @return AnyObject (ScalaOrgCh,ScalaLocationCh,ScalaSystemCh,ScalaExperienceCh).
*/
public func getChannel(typeChannel:SOCKET_CHANNELS) -> Any{
    return socketManager.getChannel(typeChannel)
}




