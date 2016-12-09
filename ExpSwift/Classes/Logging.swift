//
//  Logging.swift
//  Pods
//
//  Created by Cesar on 1/13/16.
//
//

import Foundation

func expLogging<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        let value = object()
        let stringRepresentation: String
        
        if let value = value as? CustomDebugStringConvertible {
            stringRepresentation = value.debugDescription
        } else if let value = value as? CustomStringConvertible {
            stringRepresentation = value.description
        } else {
            fatalError("epxLoggingPrint only works for values that conform to CustomDebugStringConvertible or CustomStringConvertible")
        }
        
        let fileURL = URL(string: file)?.lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "UI" : "BG"
        
        print("<\(queue)> \(fileURL) \(function)[\(line)]: " + stringRepresentation)
    #endif
}
    
