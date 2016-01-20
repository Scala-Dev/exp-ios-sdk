//
//  Logging.swift
//  Pods
//
//  Created by Cesar on 1/13/16.
//
//

import Foundation


func expLogging<T>(@autoclosure object: () -> T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) {
        #if DEBUG
            let value = object()
            let stringRepresentation: String
            
            if let value = value as? CustomDebugStringConvertible {
                stringRepresentation = value.debugDescription
            } else if let value = value as? CustomStringConvertible {
                stringRepresentation = value.description
            } else {
                fatalError("expLogging only works for values that conform to CustomDebugStringConvertible or CustomStringConvertible")
            }
            
            let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
            let queue = NSThread.isMainThread() ? "UI" : "BG"
            
            NSLog("<\(queue)> \(fileURL) \(function)[\(line)]: " + stringRepresentation)
        #endif
}
    
