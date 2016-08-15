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
    
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            self.uuid = representation["uuid"] as! String
            self.subtype = CONTENT_TYPES(rawValue: representation["subtype"] as! String)!
        } else {
            self.uuid = ""
            self.subtype = CONTENT_TYPES.UNKNOWN
        }
        
        if let childrenPath = representation.valueForKeyPath("children") as? [[String: AnyObject]] {
            self.children = Content.collection(response:response, representation: childrenPath)
        }
        
        super.init(response: response, representation: representation)
        
        // remove children from document
        document["children"] = nil
    }
    
     public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Content] {
        var contents: [Content] = []
            if let representation = representation as? [[String: AnyObject]] {
                for contentRepresentation in representation {
                    if let content = Content(response: response, representation: contentRepresentation) {
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
    public func getChildren() ->Promise<[Content]>{
        if (!children.isEmpty) {
            return Promise<[Content]> { fulfill, reject in
                fulfill(children)
            }
        } else {
            return Promise { fulfill, reject in
                Alamofire.request(Router.getContent(uuid) )
                    .responseObject { (response: Response<Content, NSError>) in
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
        
        let rt = auth?.get("restrictedToken") as! String
        
        switch(self.subtype) {
        case .FILE:
            let escapeUrl = self.document["path"]!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            return "\(hostUrl)/api/delivery\(escapeUrl)?_rt=\(rt)"
        case .APP:
            let escapeUrl = self.document["path"]!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
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
    public func getVariantUrl (name: String) -> String? {

        if(CONTENT_TYPES.FILE == self.subtype && hasVariant(name)){
            if let url = getUrl() {
                let rt = auth?.get("restrictedToken") as! String
                let variant = name.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                return "\(url)&variant=\(variant)"
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
