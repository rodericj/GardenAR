import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "roderic",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor",
        database: Environment.get("DATABASE_NAME") ?? "gardenar"
    ), as: .psql)

    app.migrations.add(CreateSpace())
    app.migrations.add(CreateAnchor())
    app.migrations.add(CreateAnchorMetadata())
    try app.autoMigrate().wait()
    // register routes
    try routes(app)
}
