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
    
    func findDriver(forUser user: User, location: SharedLocation) -> User? {
        if drivers.isEmpty {
            return nil
        }
        var maxValue = -1.0
        var maxDriver: DriverData?
        for driver in drivers {
            if abs(driver.location.latitude - location.latitude) > 0.01 && abs(driver.location.longitude - location.longitude) > 0.01 {
                continue
            }
            let predict = NeuralNetworkManager.shared.predict(x: NeuralNetworkManager.convertX(driver: driver.user, client: user))
            if predict > maxValue {
                maxValue = predict
                maxDriver = driver
            }
        }
        if let maxDriver {
            removeDriver(maxDriver)
        }
        return maxDriver?.user
    }
    
}
