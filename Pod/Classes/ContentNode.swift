//
//  Content.swift
//  Pods
//
//  Created by Cesar on 9/23/15.
//
//

import Foundation
import PromiseKit

public final class ContentNode: ResponseObject,ResponseCollection {
    public var document: [String:AnyObject] = [String:AnyObject]()
    public var children: [ContentNode] = []
    
    public enum CONTENT_TYPES : String {
        case APP = "scala:content:app"
        case FILE = "scala:content:file"
        case FOLDER = "scala:content:folder"
        case URL = "scala:content:url"
    }
    
    
    @objc required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
         if let representation = representation as? [String: AnyObject] {
            for documentRep in representation{
                if("children" != documentRep.0){
                    document.updateValue(documentRep.1, forKey: documentRep.0)
                }
            }
            
        }
        if let childrenPath = representation.valueForKeyPath("children") as? [[String: AnyObject]] {
            self.children = ContentNode.collection(response:response, representation: childrenPath)
        }
    }
    
    @objc public static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [ContentNode] {
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
        let childrenPromise = Promise<[ContentNode]> { fulfill, reject in
            if(!children.isEmpty){
                fulfill(children)
            }else{
                fulfill([])
            }
        }
        return childrenPromise
    }
    
    /**
    Get Url
    @return String.
    */
    public func getUrl () -> String? {
        let subtype: CONTENT_TYPES = CONTENT_TYPES(rawValue: self.document["subtype"] as! String)!
        
        switch(subtype) {
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
        let subtype: CONTENT_TYPES = CONTENT_TYPES(rawValue: self.document["subtype"] as! String)!
        
        if(CONTENT_TYPES.FILE == subtype && hasVariant(name)){
            var urlPath = getUrl()
            if (urlPath != nil) {
                return urlPath! + "?variant=" + name.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            }
        }
        
        return nil
    }
    
    public func hasVariant (name: String) ->Bool{
        if (self.document["variants"] != nil) {
            let variants = self.document["variants"] as! [String:AnyObject]
            return variants[name] != nil
        }
        
        return false;
    }
}
