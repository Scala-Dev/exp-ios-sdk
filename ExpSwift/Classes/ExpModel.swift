//
//  ExpModel.swift
//  Pods
//
//  Created by Cesar on 11/21/16.
//
//

import Foundation
import PromiseKit

public protocol ExpModel {
    func save() -> Promise<Self>
    func refresh() -> Promise<Self>
}
