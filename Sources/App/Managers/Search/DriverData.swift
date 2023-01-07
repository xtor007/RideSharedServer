//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 07.01.2023.
//

import Foundation

struct DriverData {
    let user: User
    let location: SharedLocation
    let callback: (User) -> Void
}
