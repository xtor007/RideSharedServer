import Vapor
import JWT

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    
    let corsMiddleware = CORSMiddleware(configuration: .default())
    app.middleware.use(corsMiddleware)
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.jwt.signers.use(.hs256(key: Enviroment.secretKey))
    
    for db in Database.allCases {
        do {
            Task {
                try await DBManager.shared.connectDB(db)
            }
        }
    }
    
    // register routes
    try routes(app)
}
