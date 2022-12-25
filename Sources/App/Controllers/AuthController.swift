//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 24.12.2022.
//

import Foundation
import Vapor
import JWT

struct AuthController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let authRoutes = routes.grouped("auth")
        authRoutes.post("signIn", use: auth)
    }
    
    func auth(req: Request) async throws -> User {
        let user = try await req.jwt.google.verify()
        return User(
            name: user.name!,
            avatar: user.picture,
            rating: 3.2,
            tripCount: 5
        )
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
