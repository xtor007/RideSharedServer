//
//  SelectionParameters.swift
//  RideShared
//
//  Created by Anatoliy Khramchenko on 20.12.2022.
//

import Foundation
import Vapor
import MongoKitten

struct SelectionParametrs: Content {
    var musicalPreferences: String?
    var musicalPrioritet: Int
    var driverGenderIndex: Int?
    var genderPrioritet: Int
    var driverMinAge: Int?
    var driverMaxAge: Int?
    var agePrioritet: Int
    var speedIndex: Int?
    var speedPrioritet: Int
    var carColorIndex: Int?
    var colorPrioritet: Int
}

extension SelectionParametrs {
    
    init?(document: Document) {
        guard let musicalPrioritet = document[Database.UsersCollection.UsersField.musicalPrioritet.rawValue] as? Int else {
            return nil
        }
        guard let genderPrioritet = document[Database.UsersCollection.UsersField.genderPrioritet.rawValue] as? Int else {
            return nil
        }
        guard let agePrioritet = document[Database.UsersCollection.UsersField.agePrioritet.rawValue] as? Int else {
            return nil
        }
        guard let speedPrioritet = document[Database.UsersCollection.UsersField.speedPrioritet.rawValue] as? Int else {
            return nil
        }
        guard let colorPrioritet = document[Database.UsersCollection.UsersField.colorPrioritet.rawValue] as? Int else {
            return nil
        }
        self = SelectionParametrs(
            musicalPreferences: document[Database.UsersCollection.UsersField.musicalPreferences.rawValue] as? String,
            musicalPrioritet: musicalPrioritet,
            driverGenderIndex: document[Database.UsersCollection.UsersField.driverGenderIndex.rawValue] as? Int,
            genderPrioritet: genderPrioritet,
            driverMinAge: document[Database.UsersCollection.UsersField.driverMinAge.rawValue] as? Int,
            driverMaxAge: document[Database.UsersCollection.UsersField.driverMaxAge.rawValue] as? Int,
            agePrioritet: agePrioritet,
            speedIndex: document[Database.UsersCollection.UsersField.speedIndex.rawValue] as? Int,
            speedPrioritet: speedPrioritet,
            carColorIndex: document[Database.UsersCollection.UsersField.carColorIndex.rawValue] as? Int,
            colorPrioritet: colorPrioritet
        )
    }
    
    func getDocumentDescription() ->  [String:Primitive] {
        var document = [String:Primitive]()
        if let musicalPreferences {
            document[Database.UsersCollection.UsersField.musicalPreferences.rawValue] = musicalPreferences
        }
        document[Database.UsersCollection.UsersField.musicalPrioritet.rawValue] = musicalPrioritet
        if let driverGenderIndex {
            document[Database.UsersCollection.UsersField.driverGenderIndex.rawValue] = driverGenderIndex
        }
        document[Database.UsersCollection.UsersField.genderPrioritet.rawValue] = genderPrioritet
        if let driverMinAge {
            document[Database.UsersCollection.UsersField.driverMinAge.rawValue] = driverMinAge
        }
        if let driverMaxAge {
            document[Database.UsersCollection.UsersField.driverMaxAge.rawValue] = driverMaxAge
        }
        document[Database.UsersCollection.UsersField.agePrioritet.rawValue] = agePrioritet
        if let speedIndex {
            document[Database.UsersCollection.UsersField.speedIndex.rawValue] = speedIndex
        }
        document[Database.UsersCollection.UsersField.speedPrioritet.rawValue] = speedPrioritet
        if let carColorIndex {
            document[Database.UsersCollection.UsersField.carColorIndex.rawValue] = carColorIndex
        }
        document[Database.UsersCollection.UsersField.colorPrioritet.rawValue] = colorPrioritet
        return document
    }
    
}
