import Vapor
import JWT

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    
    let corsMiddleware = CORSMiddleware(configuration: .default())
    app.middleware.use(corsMiddleware)
    
    app.jwt.signers.use(.hs256(key: Enviroment.secretKey))
    
    // register routes
    try routes(app)
}
