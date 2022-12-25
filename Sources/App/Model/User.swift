//
//  User.swift
//  RideShared
//
//  Created by Anatoliy Khramchenko on 17.12.2022.
//

import Foundation
import Vapor

struct User: Content {
    var name: String
    var avatar: String?
    var rating: Double
    var tripCount: Int
    var selectionParametrs: SelectionParametrs?
    var taxiData: TaxiData?
}
