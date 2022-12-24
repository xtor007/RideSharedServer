//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 24.12.2022.
//

import Foundation
import Vapor

struct AuthController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let authRoutes = routes.grouped("auth")
        authRoutes.post("singIn", use: auth)
    }
    
    func auth(req: Request) throws -> User {
        return User(
            name: "Server",
            rating: 3.2,
            tripCount: 5
        )
    }
    
}
