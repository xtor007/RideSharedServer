//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 09.01.2023.
//

import Vapor
import MongoKitten

struct NeuralNetworkController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let neuralRoutes = routes.grouped("neural")
        neuralRoutes.get("train", use: train)
        neuralRoutes.get("testDrivers", use: addTestDrivers)
    }
    
    func train(req: Request) async throws -> String {
        let trips = try DBManager.shared.getMongoCollection(db: .users, collection: Database.UsersCollection.trips)
        let users = try DBManager.shared.getMongoCollection(db: .users, collection: Database.UsersCollection.users)
        let tripData = trips.find()
        var x = [[Double]]()
        var y = [Double]()
        for try await trip in try await tripData.execute() {
            if let trip = Trip(document: trip) {
                guard let driverDoc = try await users.findOne(Database.UsersCollection.UsersField.email.rawValue == trip.driverEmail) else {
                    continue
                }
                guard let driver = User(document: driverDoc) else {
                    continue
                }
                guard let clientDoc = try await users.findOne(Database.UsersCollection.UsersField.email.rawValue == trip.clientEmail) else {
                    continue
                }
                guard let client = User(document: clientDoc) else {
                    continue
                }
                x.append(NeuralNetworkManager.convertX(driver: driver, client: client))
                y.append(NeuralNetworkManager.convertY(trip: trip))
            }
        }
        let trainX = Array(x[0 ..< x.count * 4 / 5])
        let testX = Array(x[x.count * 4 / 5 ..< x.count])
        let trainY = Array(y[0 ..< y.count * 4 / 5])
        let testY = Array(y[y.count * 4 / 5 ..< y.count])
        NeuralNetworkManager.shared.train(x: trainX, y: trainY)
        var mse = 0.0
        for exampleIndex in 0..<testX.count {
            mse += pow(testY[exampleIndex] - NeuralNetworkManager.shared.predict(x: testX[exampleIndex]), 2)
        }
        return "MSE = \(mse / Double(x.count))"
    }
    
    func addTestDrivers(req: Request) async throws -> String {
        let users = try DBManager.shared.getMongoCollection(db: .users, collection: Database.UsersCollection.users)
        for driverIndex in 1...4 {
            guard let driverDoc = try await users.findOne(Database.UsersCollection.UsersField.email.rawValue == "driver\(driverIndex)@m.com") else {
                continue
            }
            guard let driver = User(document: driverDoc) else {
                continue
            }
            SearchManager.shared.addDriver(DriverData(
                user: driver,
                location: SharedLocation(latitude: 51.865004, longitude: 33.477455),
                callback: { user in
                    print(user)
                }
            ))
        }
        return "Drivers was added"
    }
    
}
