//
//  Model.swift
//  Pods
//
//  Created by Adam Galloway on 10/9/15.
//
//

import Foundation
import PromiseKit

public  class Model  {
    
    var document: [String:Any] = [String:Any]()
    
    
     required public init?(response: HTTPURLResponse?, representation: Any?) {
        if let representation = representation as? [String: AnyObject] {
            for documentRep in representation{
                self.document.updateValue(documentRep.1, forKey: documentRep.0)
            }
        }
    }
    
    open func getUuid()->String{
       return self.document["uuid"] as! String
    }
    
    open func getDocument() -> [String:Any] {
        return self.document
    }
    
    open func get(_ name:String) -> Any? {
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
    
    
    open func getChannelName()->String{
        return self.getUuid()
    }
    
    
    open func getChannel() -> Channel{
        return ExpSwift.getChannel(getChannelName(), system: false, consumerApp: false)
    }
    
    open func getChannel(system:Bool,consumer:Bool) -> Channel{
        return ExpSwift.getChannel(getChannelName(), system: system, consumerApp: consumer)
    }
    
    open func setProperty(name:String,value:Any) -> Void{
       self.document.updateValue(value, forKey: name)
    }
}


