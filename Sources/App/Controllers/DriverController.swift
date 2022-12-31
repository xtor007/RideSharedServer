//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 29.12.2022.
//

import Foundation
import Vapor
import MongoKitten

struct EmailData: Content {
    var email: String
}

struct DriverController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let authRoutes = routes.grouped("driver")
        authRoutes.post("driverConfirmed", use: driverConfirmed)
        authRoutes.post("confirm", use: confirm)
    }
    
    func driverConfirmed(req: Request) async throws -> HTTPStatus {
        let tokenManager = TokenManager()
        do {
            let user = try tokenManager.getUser(fromReq: req)
            let mailManager = MailManager()
            mailManager.sendConfirmedMail(user: user) { error in
                print(error)
            }
        } catch {
            throw error
        }
        return .ok
    }
    
    func confirm(req: Request) async throws -> String {
        do {
            let emailData = try req.content.decode(EmailData.self)
            print(emailData.email)
        } catch {
            print(error)
        }
        return "EHOOOOOO"
    }
    
}
