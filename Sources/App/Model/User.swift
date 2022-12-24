//
//  User.swift
//  RideShared
//
//  Created by Anatoliy Khramchenko on 17.12.2022.
//

import Foundation

struct User {
    var name: String
    var avatar: Data?
    var rating: Double
    var tripCount: Int
    var selectionParametrs: SelectionParametrs?
    var taxiData: TaxiData?
}

extension User {
    static let preview = User(
        name: "Anatolii Khramchenko",
        rating: 5.0,
        tripCount: 1
    )
}
