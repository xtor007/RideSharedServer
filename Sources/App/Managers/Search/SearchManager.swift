//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 07.01.2023.
//

import Foundation

class SearchManager {
    
    static let shared = SearchManager()
    
    private(set) var drivers = [DriverData]()
    
    private init() {}
    
    func addDriver(_ data: DriverData) {
        drivers.append(data)
    }
    
    func removeDriver(_ data: DriverData) {
        drivers.removeAll { driverData in
            driverData.user.email == data.user.email
        }
    }
    
    func findDriver(forUser user: User) -> User? {
        if drivers.isEmpty {
            return nil
        }
        drivers[0].callback(user)
        let driver = drivers[0].user
        removeDriver(drivers[0])
        return driver
    }
    
}
