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
    public let created: String
    public let primaryType: String
    public let name: String
    public let path: String?
    public let uuid: String
    public let folderCount: Int?
    public let itemCount: Int?
    public let parent: String?
    public let subtype: String?
    public let mimeType: String?
    public let lastModified: String?
    public let size: Int?
    public let labels: [String]?
    public let status: String?
    public var children: [ContentNode] = []
    
    @objc required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.name = representation.valueForKeyPath("name") as! String
        self.created = representation.valueForKeyPath("created") as! String
        self.primaryType = representation.valueForKeyPath("primaryType") as! String
        self.uuid = representation.valueForKeyPath("uuid") as! String
        self.folderCount = representation.valueForKeyPath("folderCount") as? Int
        self.itemCount = representation.valueForKeyPath("itemCount") as? Int
        self.parent = representation.valueForKeyPath("parent") as? String
        self.subtype = representation.valueForKeyPath("subtype") as? String
        self.mimeType = representation.valueForKeyPath("mimeType") as? String
        self.path = representation.valueForKeyPath("path") as? String
        self.lastModified = representation.valueForKeyPath("lastModified") as? String
        self.size = representation.valueForKeyPath("size") as? Int
        self.labels = representation.valueForKeyPath("labels") as? NSArray as? [String]
        self.status = representation.valueForKeyPath("status") as? String
        if let childrenPath = representation.valueForKeyPath("children") as? [[String: AnyObject]] {
            self.children = ContentNode.collection(response:response, representation: childrenPath)
        }
    }
    
    @objc public static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [ContentNode] {
        var contents: [ContentNode] = []
        
            println(representation)
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
                reject(NSError())
            }
        }
        return childrenPromise
    }
    
    /**
    Get Url
    @return String.
    */
    public func getUrl () ->String{
        var escapeUrl = self.path!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        return hostUrl + "/api/delivery" + escapeUrl!
    }
}
