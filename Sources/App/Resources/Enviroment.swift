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
    static let senderEmail = ProcessInfo.processInfo.environment["senderEmail"]!
    static let senderPassword = ProcessInfo.processInfo.environment["senderPassword"]!
    static let adminEmail = ProcessInfo.processInfo.environment["adminEmail"]!
    static let selfLink = ProcessInfo.processInfo.environment["selfLink"]!
}
