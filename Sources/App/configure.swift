import Vapor
import JWT

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.jwt.signers.use(.hs256(key: ProcessInfo.processInfo.environment[Enviroment.secretKey]!))
    
    // register routes
    try routes(app)
}
