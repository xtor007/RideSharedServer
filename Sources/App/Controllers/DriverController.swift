//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 29.12.2022.
//

import Foundation
import Vapor
import MongoKitten

struct DriverController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let authRoutes = routes.grouped("driver")
        authRoutes.post("driverConfirmed", use: driverConfirmed)
    }
    
    func driverConfirmed(req: Request) async throws -> HTTPStatus {
        let tokenManager = TokenManager()
        do {
            let user = try tokenManager.getUser(fromReq: req)
            
        } catch {
            throw error
        }
        return .ok
    }
    
}
