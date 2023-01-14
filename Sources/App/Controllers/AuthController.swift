//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 24.12.2022.
//

import Foundation
import Vapor
import JWT
import MongoKitten

struct AuthController: RouteCollection {

    func boot(routes: Vapor.RoutesBuilder) throws {
        let authRoutes = routes.grouped("auth")
        authRoutes.get("signIn", use: auth)
        authRoutes.get("updateUser", use: updateUser)
    }

    func auth(req: Request) async throws -> User {
        let user = try await req.jwt.google.verify()
        if let email = user.email, let name = user.name {
            do {
                let users = try DBManager.shared.getMongoCollection(db: .users, collection: Database.UsersCollection.users)
                if let userDoc = try await users.findOne(Database.UsersCollection.UsersField.email.rawValue == email) {
                    if let dbUser = User(document: userDoc) {
                        return dbUser
                    } else {
                        throw Abort(.conflict)
                    }
                } else {
                    let newUser = User(
                        name: name,
                        email: email,
                        avatar: user.picture,
                        rating: 5.0,
                        tripCount: 0
                    )
                    try await users.insert(newUser.getDocument())
                    return newUser
                }
            } catch {
                throw error
            }
        } else {
            throw Abort(.badRequest, reason: "This account haven't email or name")
        }
    }

    func updateUser(req: Request) async throws -> HTTPStatus {
        let tokenManager = TokenManager()
        do {
            let user = try tokenManager.getUser(fromReq: req)
            let users = try DBManager.shared.getMongoCollection(db: .users, collection: Database.UsersCollection.users)
            try await users.updateOne(where: Database.UsersCollection.UsersField.email.rawValue == user.email, to: user.getDocument())
        } catch {
            throw error
        }
        return .ok
    }

}
