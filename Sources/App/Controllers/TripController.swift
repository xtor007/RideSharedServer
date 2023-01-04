//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 04.01.2023.
//

import Vapor

struct TripController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let tripRoutes = routes.grouped("trip")
        tripRoutes.post("getDriver", use: getDriver)
    }
    
    func getDriver(req: Request) async throws -> User {
        return User(name: "Driver", email: "a@a", rating: 5.0, tripCount: 0)
    }
    
}
