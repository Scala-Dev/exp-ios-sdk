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

public final class ContentNode: Model,ResponseObject,ResponseCollection {

    var children: [ContentNode] = []
    public let uuid: String
    public let subtype: CONTENT_TYPES

    public enum CONTENT_TYPES : String {
        case APP = "scala:content:app"
        case FILE = "scala:content:file"
        case FOLDER = "scala:content:folder"
        case URL = "scala:content:url"
        case UNKNOWN = ""
    }
    
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            self.uuid = representation["uuid"] as! String
            self.subtype = CONTENT_TYPES(rawValue: representation["subtype"] as! String)!
        } else {
            self.uuid = ""
            self.subtype = CONTENT_TYPES.UNKNOWN
        }
        
        if let childrenPath = representation.valueForKeyPath("children") as? [[String: AnyObject]] {
            self.children = ContentNode.collection(response:response, representation: childrenPath)
        }
        
        super.init(response: response, representation: representation)
        
        // remove children from document
        document["children"] = nil
    }
    
     public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [ContentNode] {
        var contents: [ContentNode] = []
            if let representation = representation as? [[String: AnyObject]] {
                for contentRepresentation in representation {
                    if let content = ContentNode(response: response, representation: contentRepresentation) {
                        contents.append(content)
                    }
                }
            }
        return contents
    }
    
    /**
    Get Children from Node
    @return Promise<[Content]>.
    */
    public func getChildren() ->Promise<[ContentNode]>{
        if (!children.isEmpty) {
            return Promise<[ContentNode]> { fulfill, reject in
                fulfill(children)
            }
        } else {
            return Promise { fulfill, reject in
                Alamofire.request(Router.getContentNode(uuid) )
                    .responseObject { (response: Response<ContentNode, NSError>) in
                        switch response.result{
                        case .Success(let data):
                            self.children = data.children
                            
                            fulfill(self.children)
                        case .Failure(let error):
                            return reject(error)
                        }
                }
            }
        }
    }
    
    /**
    Get Url
    @return String.
    */

    public func getUrl () -> String? {
        
        switch(self.subtype) {
        case .FILE:
            let escapeUrl = self.document["path"]!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            return hostUrl + "/api/delivery" + escapeUrl
        case .APP:
            let escapeUrl = self.document["path"]!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            return hostUrl + "/api/delivery" + escapeUrl + "/index.html"
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
    public func getVariantUrl (name: String) -> String? {

        if(CONTENT_TYPES.FILE == self.subtype && hasVariant(name)){
            if let url = getUrl() {
                return url + "?variant=" + name.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            }
        }
        
        return nil
    }
    
    public func hasVariant(name: String) -> Bool {
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
