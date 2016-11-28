//
//  ExpModel.swift
//  Pods
//
//  Created by Cesar on 11/21/16.
//
//

import Foundation
import PromiseKit

public protocol ModelProtocol {
    
    associatedtype Model
    func save () -> Model
    func refresh() -> Model
    
}
