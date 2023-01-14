//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 08.01.2023.
//

import Vapor
import Vapor
import MongoKitten

struct Trip: Content {
    var driverEmail: String
    var clientEmail: String
    var status: Int
    var date: Date
    var clientRating: Double?
    var rating: Double?
    var music: Double?
    var speed: Double?
    var start: String?
    var finish: String?
    var price: Double?
}

extension Trip {

    init?(document: Document) {
        guard let driverEmail = document[Database.UsersCollection.TripField.driverEmail.fieldName] as? String else {
            return nil
        }
        guard let clientEmail = document[Database.UsersCollection.TripField.clientEmail.fieldName] as? String else {
            return nil
        }
        guard let status = document[Database.UsersCollection.TripField.status.fieldName] as? Int else {
            return nil
        }
        guard let date = document[Database.UsersCollection.TripField.date.fieldName] as? Date else {
            return nil
        }
        self = Trip(
            driverEmail: driverEmail,
            clientEmail: clientEmail,
            status: status,
            date: date,
            clientRating: document[Database.UsersCollection.TripField.clientRating.fieldName] as? Double,
            rating: document[Database.UsersCollection.TripField.rating.fieldName] as? Double,
            music: document[Database.UsersCollection.TripField.music.fieldName] as? Double,
            speed: document[Database.UsersCollection.TripField.speed.fieldName] as? Double,
            start: document[Database.UsersCollection.TripField.start.fieldName] as? String,
            finish: document[Database.UsersCollection.TripField.finish.fieldName] as? String,
            price: document[Database.UsersCollection.TripField.price.fieldName] as? Double
        )
    }

    func getDocument() ->  Document {
        var document: Document = [:]
        document[Database.UsersCollection.TripField.driverEmail.rawValue] = driverEmail
        document[Database.UsersCollection.TripField.clientEmail.rawValue] = clientEmail
        document[Database.UsersCollection.TripField.status.rawValue] = status
        document[Database.UsersCollection.TripField.date.rawValue] = date
        if let clientRating {
            document[Database.UsersCollection.TripField.clientRating.rawValue] = clientRating
        }
        if let rating {
            document[Database.UsersCollection.TripField.rating.rawValue] = rating
        }
        if let music {
            document[Database.UsersCollection.TripField.music.rawValue] = music
        }
        if let speed {
            document[Database.UsersCollection.TripField.speed.rawValue] = speed
        }
        if let start {
            document[Database.UsersCollection.TripField.start.rawValue] = start
        }
        if let finish {
            document[Database.UsersCollection.TripField.finish.rawValue] = finish
        }
        if let price {
            document[Database.UsersCollection.TripField.price.rawValue] = price
        }
        return document
    }

}
