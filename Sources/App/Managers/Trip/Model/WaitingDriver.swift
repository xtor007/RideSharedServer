//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 10.01.2023.
//

import Foundation

struct WaitingDriver {
    let user: User
    let currentLocation: SharedLocation
    let callback: (UUID) -> Void
}
