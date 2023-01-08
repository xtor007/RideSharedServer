import Vapor
import MongoKitten

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        return "Hello, world!"
    }
    
    try app.register(collection: AuthController())
    try app.register(collection: DriverController())
    try app.register(collection: TripController())
    try app.register(collection: HistoryController())
    
}
