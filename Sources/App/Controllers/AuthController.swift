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
        authRoutes.post("signIn", use: auth)
    }
    
    func auth(req: Request) async throws -> User {
        let user = try await req.jwt.google.verify()
        if let email = user.email, let name = user.name {
            do {
                let link = MongoDBManager(db: .users).connectionLink
                let db = try await MongoDatabase.connect(
                    to: link
                )
                let users = db[Database.UsersCollection.users.rawValue]
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
            throw Abort(.badRequest, reason: "This accaunt haven't email and name")
        }
    }
    
}

/*
GoogleIdentityToken(
    issuer: JWTKit.IssuerClaim(
        value: "https://accounts.google.com"
    ), subject: JWTKit.SubjectClaim(
        value: "112609587979113556392"
    ), audience: JWTKit.AudienceClaim(
        value: ["1070319083094-rhfna9ibe6pgrun9ag7f90ogbcdmcm95.apps.googleusercontent.com"]
    ), authorizedPresenter: "1070319083094-rhfna9ibe6pgrun9ag7f90ogbcdmcm95.apps.googleusercontent.com",
    issuedAt: JWTKit.IssuedAtClaim(value: 2022-12-25 12:20:20 +0000),
    expires: JWTKit.ExpirationClaim(value: 2022-12-25 13:20:20 +0000),
    atHash: Optional("JEtCnnxVu2GlbgZkcBTptg"),
    hostedDomain: nil,
    email: Optional("tolxpams@gmail.com"),
    emailVerified: Optional(JWTKit.BoolClaim(value: true)),
    name: Optional("Anatoliy Khramchenko"),
    picture: Optional("https://lh3.googleusercontent.com/a/AEdFTp5u_m6W1MUyvUKrg8INJDr_fqwnzKdxNGx-49WM=s96-c"),
    profile: nil,
    givenName: Optional("Anatoliy"),
    familyName: Optional("Khramchenko"),
    locale: Optional(JWTKit.LocaleClaim(value: uk (fixed))),
    nonce: Optional("RKBm6toDpB-O96pwWg6LYlTtE_zMo0jiEB1qxW-hLYI")
)
*/
