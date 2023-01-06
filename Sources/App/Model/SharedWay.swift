//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 06.01.2023.
//

import Vapor

struct SharedWay: Content {
    let start: SharedLocation
    let finish: SharedLocation
}
