//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 31.12.2022.
//

import Foundation
import MongoKitten
import Vapor

class DBManager {

    static let shared = DBManager()

    private var databases = [Database : MongoDatabase]()

    private init() {}

    func connectDB(_ db: Database) async throws {
        let link = MongoDBManager(db: db).connectionLink
        do {
            databases[db] = try await MongoDatabase.connect(to: link)
        } catch {
            throw error
        }
    }

    func getMongoCollection(db: Database, collection: DBCollection) throws -> MongoCollection {
        guard let mongoDB = databases[db] else {
            throw Abort(.conflict)
        }
        return mongoDB[collection.collectionName]
    }

}
