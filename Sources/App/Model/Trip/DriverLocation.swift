//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 10.01.2023.
//

import Vapor

struct DriverLocation: Content {
    let id: UUID
    let location: SharedLocation
}
