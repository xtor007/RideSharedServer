//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 27.12.2022.
//

import Foundation

class MongoDBManager {

    let db: Database

    var connectionLink: String {
        return "\(Enviroment.mongoDBConnectionLink)\(db.rawValue)?retryWrites=true&w=majority"
    }

    init(db: Database) {
        self.db = db
    }

}
