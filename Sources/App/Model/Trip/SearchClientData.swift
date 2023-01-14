//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 10.01.2023.
//

import Vapor

struct SearchClientData: Content {
    let client: User
    let location: SharedLocation
}
