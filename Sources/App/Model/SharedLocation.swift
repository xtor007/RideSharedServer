//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 06.01.2023.
//

import Vapor

struct SharedLocation: Content {
    let latitude: Double
    let longitude: Double
    let description: String?
}
