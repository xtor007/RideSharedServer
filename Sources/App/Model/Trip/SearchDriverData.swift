//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 10.01.2023.
//

import Vapor

struct SearchDriverData: Content {
    let driver: User
    let way: SharedWay
    let price: Double
}
