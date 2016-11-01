//
//  Content.swift
//  Pods
//
//  Created by Cesar on 9/23/15.
//
//

import Foundation
import PromiseKit
import Alamofire

public final class Content: Model,ResponseObject,ResponseCollection {

    var children: [Content] = []
    public let uuid: String
    public let subtype: CONTENT_TYPES

    public enum CONTENT_TYPES : String {
        case APP = "scala:content:app"
        case FILE = "scala:content:file"
        case FOLDER = "scala:content:folder"
        case URL = "scala:content:url"
        case UNKNOWN = ""
    }
    
    required public init?(response: HTTPURLResponse, representation: Any) {
        if let representation = representation as? [String: AnyObject] {
            self.uuid = representation["uuid"] as! String
            self.subtype = CONTENT_TYPES(rawValue: representation["subtype"] as! String)!
        } else {
            self.uuid = ""
            self.subtype = CONTENT_TYPES.UNKNOWN
        }
        
                
        super.init(response: response, representation: representation)
        
        // remove children from document
        document["children"] = nil
    }
    
    
    /**
    Get Children from Node
    @return Promise<[Content]>.
    */
    public func getChildren() ->Promise<[Content]>{
        if (!children.isEmpty) {
            return Promise<[Content]> { fulfill, reject in
                fulfill(children)
            }
        } else {
            return Promise { fulfill, reject in
                Alamofire.request(Router.getContent(uuid) )
                    .responseObject { (response: DataResponse<Content>) in
                        switch response.result{
                        case .success(let data):
                            self.children = data.children
                            
                            fulfill(self.children)
                        case .failure(let error):
                            return reject(error)
                        }
                }
            }
        }
    }
    
    /**
     Get Children from with params
     @return Promise<[Content]>.
     */
    public func getChildren(_ params:[String:AnyObject]) ->Promise<SearchResults<Content>>{
        var params = params
        params.updateValue(uuid as AnyObject, forKey: "parent")
            return Promise { fulfill, reject in
                Alamofire.request(Router.findContent(params))
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
    Get Url
    @return String.
    */

    public func getUrl () -> String? {
        
        let rt = auth?.get("restrictedToken") as! String
        
        switch(self.subtype) {
        case .FILE:
            let escapeUrl = (self.document["path"]! as! String).addingPercentEscapes(using: String.Encoding.utf8)!
            return "\(hostUrl)/api/delivery\(escapeUrl)?_rt=\(rt)"
        case .APP:
            let escapeUrl = (self.document["path"]! as! String).addingPercentEscapes(using: String.Encoding.utf8)!
            return "\(hostUrl)/api/delivery\(escapeUrl)/index.html?_rt=\(rt)"
        case .URL:
            return self.document["url"] as? String
        default:
            return nil
        }
    }
    
    /**
    Get Url to a file variant
    @return String.
    */
    public func getVariantUrl (_ name: String) -> String? {

        if(CONTENT_TYPES.FILE == self.subtype && hasVariant(name)){
            if let url = getUrl() {
                let rt = auth?.get("restrictedToken") as! String
                let variant = name.addingPercentEscapes(using: String.Encoding.utf8)!
                return "\(url)&variant=\(variant)"
            }
        }
        
        return nil
    }
    
    public func hasVariant(_ name: String) -> Bool {
        if let variants = self.document["variants"] as? [[String:AnyObject]] {
            for variant in variants {
                if(variant["name"] as! String == name){
                    return true
                }
            }
        }
        return false;
    }

}
