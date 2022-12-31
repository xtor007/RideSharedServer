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
            return Response(status: .ok, body: .init(buffer: view.data))
        } catch {
            print(error)
            throw Abort(.conflict)
        }
    }
    
    func notConfirm(req: Request) async throws -> Response {
        do {
            let emailData = try req.content.decode(EmailData.self)
            let view = try await req.view.render(req.application.directory.publicDirectory + "notSuccess.html")
            return Response(status: .ok, body: .init(buffer: view.data))
        } catch {
            print(error)
            throw Abort(.conflict)
        }
    }
    
}
