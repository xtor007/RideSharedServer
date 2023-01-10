//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 10.01.2023.
//

import Foundation
import Vapor
import MongoKitten

class TripManager {
    
    static let shared = TripManager()
    
    var trips = [UUID: TripData]()
    
    var waitingUsers = [WaitingUser]()
    var waitingDrivers = [WaitingDriver]()
    
    var clientSideRating = [UUID: (Double, Double, Double)]()
    var driverSideRating = [UUID: Double]()
    
    private init() {}
    
    func findDriver(driver: User, client: User, startLocation: SharedLocation, finishLocation: SharedLocation, price: Double, callback: @escaping (UUID) -> Void) {
        let driverData = waitingDrivers.first(where: { waitingDriver in
            waitingDriver.user.email == driver.email
        })
        waitingDrivers.removeAll { waitingDriver in
            waitingDriver.user.email == driver.email
        }
        if let driverData {
            let id = UUID()
            driverData.callback(id)
            callback(id)
            trips[id] = TripData(
                client: client,
                driver: driver,
                price: price,
                startLocation: startLocation,
                finishLocation: finishLocation,
                driverLocation: driverData.currentLocation
            )
        } else {
            waitingUsers.append(WaitingUser(
                user: client,
                startLocation: startLocation,
                finishLocation: finishLocation,
                price: price,
                callback: callback
            ))
        }
    }
    
    func findClient(driver: User, client: User, currentLocation: SharedLocation, callback: @escaping (UUID) -> Void) {
        let clientData = waitingUsers.first(where: { waitingUser in
            waitingUser.user.email == client.email
        })
        waitingUsers.removeAll { waitingUser in
            waitingUser.user.email == client.email
        }
        if let clientData {
            let id = UUID()
            callback(id)
            clientData.callback(id)
            trips[id] = TripData(
                client: client,
                driver: driver,
                price: clientData.price,
                startLocation: clientData.startLocation,
                finishLocation: clientData.finishLocation,
                driverLocation: currentLocation
            )
        } else {
            waitingDrivers.append(WaitingDriver(
                user: driver,
                currentLocation: currentLocation,
                callback: callback
            ))
        }
    }
    
    func removeMe(user: User) {
        waitingUsers.removeAll { waitingUser in
            waitingUser.user.email == user.email
        }
        waitingDrivers.removeAll { waitingDriver in
            waitingDriver.user.email == user.email
        }
    }
    
    func getDriverLocation(id: UUID) -> SharedLocation? {
        return trips[id]?.driverLocation
    }
    
    func setDriverLocation(id: UUID, location: SharedLocation) {
        trips[id]?.driverLocation = location
    }
    
    func setRatingForDriver(id: UUID, rating: Double, music: Double, speed: Double) async throws {
        if let clientRating = driverSideRating[id] {
            driverSideRating.removeValue(forKey: id)
            let tripData = trips[id]!
            trips.removeValue(forKey: id)
            try await saveTrip(Trip(
                driverEmail: tripData.driver.email,
                clientEmail: tripData.client.email,
                status: 1,
                date: .now,
                clientRating: clientRating,
                rating: rating,
                music: music,
                speed: speed,
                start: tripData.startLocation.description,
                finish: tripData.finishLocation.description
            ))
        } else {
            clientSideRating[id] = (rating, music, speed)
        }
    }
    
    func setRatingForClient(id: UUID, clientRating: Double) async throws {
        if let (rating, music, speed) = clientSideRating[id] {
            clientSideRating.removeValue(forKey: id)
            let tripData = trips[id]!
            trips.removeValue(forKey: id)
            try await saveTrip(Trip(
                driverEmail: tripData.driver.email,
                clientEmail: tripData.client.email,
                status: 1,
                date: .now,
                clientRating: clientRating,
                rating: rating,
                music: music,
                speed: speed,
                start: tripData.startLocation.description,
                finish: tripData.finishLocation.description
            ))
        } else {
            driverSideRating[id] = clientRating
        }
    }
    
    private func saveTrip(_ trip: Trip) async throws {
        let trips = try DBManager.shared.getMongoCollection(db: .users, collection: Database.UsersCollection.trips)
        try await trips.insert(trip.getDocument())
    }
    
}
