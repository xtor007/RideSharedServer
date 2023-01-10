//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 10.01.2023.
//

import Foundation

struct WaitingUser {
    let user: User
    let startLocation: SharedLocation
    let finishLocation: SharedLocation
    let price: Double
    let callback: (UUID) -> Void
}
