//
//  Model.swift
//  Pods
//
//  Created by Adam Galloway on 10/9/15.
//
//

import Foundation

public class Model {
    
    var document: [String:AnyObject] = [String:AnyObject]()
    
     required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: AnyObject] {
            for documentRep in representation{
                self.document.updateValue(documentRep.1, forKey: documentRep.0)
            }
        }
    }

    public func getDocument() -> [String:AnyObject] {
        return self.document
    }
    
    public func get(name:String) -> AnyObject? {
        var dict = self.document
        let paths = name.characters.split {$0 == "."}.map(String.init)
        for path in paths {
            if (paths.last == path) {
                return dict[path]
            } else {
                dict = dict[path] as! [String:AnyObject]
            }
        }
        
        return nil
    }
    
    
    public func fling(channel:Channel,payload:[String:AnyObject]){
        channel.fling(payload)
    }
}