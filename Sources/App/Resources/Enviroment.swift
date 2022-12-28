//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 25.12.2022.
//

import Foundation

enum Enviroment {
    static let secretKey = ProcessInfo.processInfo.environment["secretKey"]!
    static let mongoDBConnectionLink = ProcessInfo.processInfo.environment["mongoDBConnectionLink"]!
}
