//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 10.01.2023.
//

import Foundation

struct TripData {
    let client: User
    let driver: User
    let price: Double
    let startLocation: SharedLocation
    let finishLocation: SharedLocation
    var driverLocation: SharedLocation
}
