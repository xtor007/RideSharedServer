//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 10.01.2023.
//

import Vapor

struct Rating: Content {
    let id: UUID
    let rating: Double
    let music: Double?
    let speed: Double?
}
