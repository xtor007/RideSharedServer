//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 04.01.2023.
//

import Vapor
import MongoKitten

struct TripController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let tripRoutes = routes.grouped("trip")
        tripRoutes.post("getDriver", use: getDriver)
    }
    
    func getDriver(req: Request) async throws -> User {
        let tokenManager = TokenManager()
        do {
            let user = try tokenManager.getUser(fromReq: req)
            let users = try DBManager.shared.getMongoCollection(db: .users, collection: Database.UsersCollection.users)
            guard let _ = try await users.findOne(Database.UsersCollection.UsersField.email.rawValue == user.email) else {
                throw Abort(.badRequest)
            }
            print(user)
            let way = try req.content.decode(SharedWay.self)
            print(way)
        } catch {
            throw error
        }
        return User(name: "Driver", email: "a@a", rating: 5.0, tripCount: 0)
    }
    
}
