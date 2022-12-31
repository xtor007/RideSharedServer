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
        let driverRoutes = routes.grouped("driver")
        driverRoutes.post("driverConfirmed", use: driverConfirmed)
        driverRoutes.post("confirm", use: confirm)
        driverRoutes.post("notConfirm", use: notConfirm)
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
    
    func confirm(req: Request) async throws -> Response {
        do {
            let emailData = try req.content.decode(EmailData.self)
            let view = try await req.view.render(req.application.directory.publicDirectory + "success.html")
            try await updateDriverData(email: emailData.email, updatedUser: { user in
                var newUser = user
                guard var taxiData = user.taxiData else {
                    throw Abort(.badRequest)
                }
                taxiData.isConfirmed = true
                newUser.taxiData = taxiData
                return newUser
            })
            return Response(status: .ok, body: .init(buffer: view.data))
        } catch {
            throw Abort(.conflict)
        }
    }
    
    func notConfirm(req: Request) async throws -> Response {
        do {
            let emailData = try req.content.decode(EmailData.self)
            let view = try await req.view.render(req.application.directory.publicDirectory + "success.html")
            try await updateDriverData(email: emailData.email) { user in
                var newUser = user
                newUser.taxiData = nil
                return newUser
            }
            return Response(status: .ok, body: .init(buffer: view.data))
        } catch {
            throw Abort(.conflict)
        }
    }
    
    func updateDriverData(email: String, updatedUser: @escaping (User) throws -> User) async throws {
        let users = try DBManager.shared.getMongoCollection(db: .users, collection: Database.UsersCollection.users)
        guard let userDoc = try await users.findOne(Database.UsersCollection.UsersField.email.fieldName == email) else {
            throw Abort(.badRequest)
        }
        guard let user = User(document: userDoc) else {
            throw Abort(.badRequest)
        }
        try await users.updateOne(
            where: Database.UsersCollection.UsersField.email.fieldName == email,
            to: updatedUser(user).getDocument()
        )
    }
    
}
