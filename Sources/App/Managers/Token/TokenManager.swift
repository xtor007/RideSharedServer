//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 27.12.2022.
//

import Vapor

class TokenManager {

    func getUser(fromReq req: Request) throws -> User {
        if let authorizationHeader = req.headers.bearerAuthorization {
            let jwt = authorizationHeader.token.replacingOccurrences(of: "Bearer ", with: "")
            let jwtComponents = jwt.components(separatedBy: ".")
            let payload = jwtComponents[1]
            if let decodedPayload = Data(base64Encoded: payload, options: .ignoreUnknownCharacters) {
                do {
                    let user = try JSONDecoder().decode(User.self, from: decodedPayload)
                    return user
                } catch {
                    throw error
                }
            } else {
                throw Abort(.badRequest)
            }
        } else {
            throw Abort(.badRequest)
        }
    }

}
