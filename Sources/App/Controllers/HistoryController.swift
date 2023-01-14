//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 08.01.2023.
//

import Vapor
import MongoKitten

struct HistoryController: RouteCollection {

    func boot(routes: Vapor.RoutesBuilder) throws {
        let historyRoutes = routes.grouped("history")
        historyRoutes.get("getAllTrips", use: getAllTrips)
    }

    func getAllTrips(req: Request) async throws -> [Trip] {
        let tokenManager = TokenManager()
        do {
            let user = try tokenManager.getUser(fromReq: req)
            let trips = try DBManager.shared.getMongoCollection(db: .users, collection: Database.UsersCollection.trips)
            let tripData = trips.find(Database.UsersCollection.TripField.clientEmail.fieldName == user.email)
            var result = [Trip]()
            for try await trip in try await tripData.execute() {
                if let newTrip = Trip(document: trip) {
                    result.append(newTrip)
                }
            }
            return result
        } catch {
            throw error
        }
    }

}
