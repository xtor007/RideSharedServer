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
        tripRoutes.post("getClient", use: getClient)
    }
    
    func getDriver(req: Request) async throws -> User {
        let tokenManager = TokenManager()
        do {
            let user = try tokenManager.getUser(fromReq: req)
            let users = try DBManager.shared.getMongoCollection(db: .users, collection: Database.UsersCollection.users)
            guard let _ = try await users.findOne(Database.UsersCollection.UsersField.email.rawValue == user.email) else {
                throw Abort(.badRequest)
            }
            let way = try req.content.decode(SharedWay.self)
            guard let driver = SearchManager.shared.findDriver(forUser: user, location: way.start) else {
                throw Abort(.conflict)
            }
            return driver
        } catch {
            throw error
        }
    }
    
    func getClient(req: Request) async throws -> OptionalUser {
        let tokenManager = TokenManager()
        do {
            let user = try tokenManager.getUser(fromReq: req)
            let users = try DBManager.shared.getMongoCollection(db: .users, collection: Database.UsersCollection.users)
            guard let _ = try await users.findOne(Database.UsersCollection.UsersField.email.rawValue == user.email) else {
                throw Abort(.badRequest)
            }
            let location = try req.content.decode(SharedLocation.self)
            var result = OptionalUser(user: nil)
            let semaphore = DispatchSemaphore(value: 0)
            let timer = DispatchSource.makeTimerSource()
            timer.setEventHandler() {
                semaphore.signal()
            }
            timer.schedule(deadline: .now() + .seconds(40))
            if #available(OSX 10.14.3,  *) {
                timer.activate()
            }
            SearchManager.shared.addDriver(DriverData(user: user, location: location, callback: { client in
                result = OptionalUser(user: client)
                semaphore.signal()
            }))
            semaphore.wait()
            return result
        } catch {
            throw error
        }
    }
    
}
