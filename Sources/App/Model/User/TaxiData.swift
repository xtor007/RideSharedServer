//
//  TaxiData.swift
//  RideShared
//
//  Created by Anatoliy Khramchenko on 24.12.2022.
//

import Foundation
import Vapor
import MongoKitten

struct TaxiData: Content {
    var isConfirmed: Bool
    var taxiTripCount: Int
    var musicRating: Double
    var genderIndex: Int
    var dateOfBirth: Date
    var speedRating: Double
    var yourCarColorIndex: Int
}

extension TaxiData {

    init?(document: Document) {
        guard let isConfirmed = document[Database.UsersCollection.UsersField.isConfirmed.rawValue] as? Bool else {
            return nil
        }
        guard let taxiTripCount = document[Database.UsersCollection.UsersField.taxiTripCount.rawValue] as? Int else {
            return nil
        }
        guard let musicRating = document[Database.UsersCollection.UsersField.musicRating.rawValue] as? Double else {
            return nil
        }
        guard let genderIndex = document[Database.UsersCollection.UsersField.genderIndex.rawValue] as? Int else {
            return nil
        }
        guard let dateOfBirth = document[Database.UsersCollection.UsersField.dateOfBirth.rawValue] as? Date else {
            return nil
        }
        guard let speedRating = document[Database.UsersCollection.UsersField.speedRating.rawValue] as? Double else {
            return nil
        }
        guard let yourCarColorIndex = document[Database.UsersCollection.UsersField.yourCarColorIndex.rawValue] as? Int else {
            return nil
        }
        self = TaxiData(
            isConfirmed: isConfirmed,
            taxiTripCount: taxiTripCount,
            musicRating: musicRating,
            genderIndex: genderIndex,
            dateOfBirth: dateOfBirth,
            speedRating: speedRating,
            yourCarColorIndex: yourCarColorIndex
        )
    }

    func getDocumentDescription() ->  [String:Primitive] {
        var document = [String:Primitive]()
        document[Database.UsersCollection.UsersField.isConfirmed.rawValue] = isConfirmed
        document[Database.UsersCollection.UsersField.taxiTripCount.rawValue] = taxiTripCount
        document[Database.UsersCollection.UsersField.musicRating.rawValue] = musicRating
        document[Database.UsersCollection.UsersField.genderIndex.rawValue] = genderIndex
        document[Database.UsersCollection.UsersField.dateOfBirth.rawValue] = dateOfBirth
        document[Database.UsersCollection.UsersField.speedRating.rawValue] = speedRating
        document[Database.UsersCollection.UsersField.yourCarColorIndex.rawValue] = yourCarColorIndex
        return document
    }

}
