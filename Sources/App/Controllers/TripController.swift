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
        tripRoutes.post("confirmDriver", use: confirmDriver)
        tripRoutes.post("confirmClient", use: confirmClient)
        tripRoutes.post("getWay", use: getWay)
        tripRoutes.post("getDriverLocation", use: getDriverLocation)
        tripRoutes.post("postDriverLocation", use: postDriverLocation)
        tripRoutes.post("postRating", use: postRating)
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

    func confirmDriver(req: Request) async throws -> TripID {
        let tokenManager = TokenManager()
        do {
            let user = try tokenManager.getUser(fromReq: req)
            let users = try DBManager.shared.getMongoCollection(db: .users, collection: Database.UsersCollection.users)
            guard let _ = try await users.findOne(Database.UsersCollection.UsersField.email.rawValue == user.email) else {
                throw Abort(.badRequest)
            }
            let searchData = try req.content.decode(SearchDriverData.self)
            var result = TripID(id: nil)
            let semaphore = DispatchSemaphore(value: 0)
            let timer = DispatchSource.makeTimerSource()
            timer.setEventHandler() {
                semaphore.signal()
            }
            timer.schedule(deadline: .now() + .seconds(40))
            if #available(OSX 10.14.3,  *) {
                timer.activate()
            }
            TripManager.shared.findDriver(
                driver: searchData.driver,
                client: user,
                startLocation: searchData.way.start,
                finishLocation: searchData.way.finish,
                price: searchData.price
            ) { id in
                result.id = id
                semaphore.signal()
            }
            semaphore.wait()
            if result.id == nil {
                TripManager.shared.removeMe(user: user)
            }
            return result
        } catch {
            throw error
        }
    }

    func confirmClient(req: Request) async throws -> TripID {
        let tokenManager = TokenManager()
        do {
            let user = try tokenManager.getUser(fromReq: req)
            let users = try DBManager.shared.getMongoCollection(db: .users, collection: Database.UsersCollection.users)
            guard let _ = try await users.findOne(Database.UsersCollection.UsersField.email.rawValue == user.email) else {
                throw Abort(.badRequest)
            }
            let searchData = try req.content.decode(SearchClientData.self)
            var result = TripID(id: nil)
            let semaphore = DispatchSemaphore(value: 0)
            let timer = DispatchSource.makeTimerSource()
            timer.setEventHandler() {
                semaphore.signal()
            }
            timer.schedule(deadline: .now() + .seconds(60))
            if #available(OSX 10.14.3,  *) {
                timer.activate()
            }
            TripManager.shared.findClient(
                driver: user,
                client: searchData.client,
                currentLocation: searchData.location
            ) { id in
                result.id = id
                semaphore.signal()
            }
            semaphore.wait()
            if result.id == nil {
                TripManager.shared.removeMe(user: user)
            }
            return result
        } catch {
            throw error
        }
    }

    func getWay(req: Request) async throws -> SharedWay {
        let id = try req.content.decode(UUID.self)
        guard let way = TripManager.shared.getTripData(id: id) else {
            throw Abort(.conflict)
        }
        return way
    }

    func getDriverLocation(req: Request) async throws -> SharedLocation {
        let id = try req.content.decode(UUID.self)
        guard let location = TripManager.shared.getDriverLocation(id: id) else {
            throw Abort(.conflict)
        }
        return location
    }

    func postDriverLocation(req: Request) async throws -> HTTPStatus {
        let location = try req.content.decode(DriverLocation.self)
        TripManager.shared.setDriverLocation(id: location.id, location: location.location)
        return .ok
    }

    func postRating(req: Request) async throws -> HTTPStatus {
        let rating = try req.content.decode(Rating.self)
        if let music = rating.music, let speed = rating.speed {
            try await TripManager.shared.setRatingForDriver(id: rating.id, rating: rating.rating, music: music, speed: speed)
        } else {
            try await TripManager.shared.setRatingForClient(id: rating.id, clientRating: rating.rating)
        }
        return .ok
    }

}
