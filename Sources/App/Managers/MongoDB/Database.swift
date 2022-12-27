//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 27.12.2022.
//

import Foundation

enum Database: String {
    
    case users = "users"
    
    enum UsersCollection: String {
        
        case users = "users"
        
        enum UsersField: String {
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
        }
        
    }
    
}
