//
//  User.swift
//  RideShared
//
//  Created by Anatoliy Khramchenko on 17.12.2022.
//

import Foundation
import Vapor
import MongoKitten

struct User: Content {
    var name: String
    var email: String
    var avatar: String?
    var rating: Double
    var tripCount: Int
    var selectionParametrs: SelectionParametrs?
    var taxiData: TaxiData?
}

extension User {
    
    init?(document: Document) {
        guard let name = document[Database.UsersCollection.UsersField.name.rawValue] as? String else {
            return nil
        }
        guard let email = document[Database.UsersCollection.UsersField.email.rawValue] as? String else {
            return nil
        }
        guard let rating = document[Database.UsersCollection.UsersField.rating.rawValue] as? Double else {
            return nil
        }
        guard let tripCount = document[Database.UsersCollection.UsersField.tripCount.rawValue] as? Int else {
            return nil
        }
        self = User(
            name: name,
            email: email,
            avatar: document[Database.UsersCollection.UsersField.avatar.rawValue] as? String,
            rating: rating,
            tripCount: tripCount
        )
    }
    
    func getDocument() ->  Document {
        var document: Document = [:]
        document[Database.UsersCollection.UsersField.name.rawValue] = name
        document[Database.UsersCollection.UsersField.email.rawValue] = email
        if let avatar {
            document[Database.UsersCollection.UsersField.avatar.rawValue] = avatar
        }
        document[Database.UsersCollection.UsersField.rating.rawValue] = rating
        document[Database.UsersCollection.UsersField.tripCount.rawValue] = tripCount
        // selection parameter && taxi data
        return document
    }
    
}
