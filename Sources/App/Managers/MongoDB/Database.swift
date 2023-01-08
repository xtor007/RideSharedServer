//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 27.12.2022.
//

import Foundation

protocol DBCollection {
    var collectionName: String { get }
}
protocol DBDocument {
    var fieldName: String { get }
}

enum Database: String, CaseIterable {
    
    case users = "users"
    
    enum UsersCollection: String, DBCollection {

        var collectionName: String {
            return self.rawValue
        }
        
        case users = "users"
        case trips = "trips"
        
        enum UsersField: String, DBDocument {
            
            var fieldName: String {
                return self.rawValue
            }
            
            case name = "name"
            case email = "email"
            case avatar = "avatar"
            case rating = "rating"
            case tripCount = "tripCount"
            case musicalPreferences = "musicalPreferences"
            case musicalPrioritet = "musicalPrioritet"
            case driverGenderIndex = "driverGenderIndex"
            case genderPrioritet = "genderPrioritet"
            case driverMinAge = "driverMinAge"
            case driverMaxAge = "driverMaxAge"
            case agePrioritet = "agePrioritet"
            case speedIndex = "speedIndex"
            case speedPrioritet = "speedPrioritet"
            case carColorIndex = "carColorIndex"
            case colorPrioritet = "colorPrioritet"
            case isConfirmed = "isConfirmed"
            case taxiTripCount = "taxiTripCount"
            case musicRating = "musicRating"
            case genderIndex = "genderIndex"
            case dateOfBirth = "dateOfBirth"
            case speedRating = "speedRating"
            case yourCarColorIndex = "yourCarColorIndex"
            
        }
        
        enum TripField: String, DBDocument {
            
            var fieldName: String {
                return self.rawValue
            }
            
            case driverEmail = "driverEmail"
            case clientEmail = "clientEmail"
            case status = "status"
            case date = "date"
            case clientRating = "clientRating"
            case rating = "rating"
            case music = "music"
            case speed = "speed"
            case start = "start"
            case finish = "finish"
            case price = "price"
            
        }
        
    }
    
}
