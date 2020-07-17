import Fluent
import Vapor
func routes(_ app: Application) throws {
    try app.register(collection: WorldController())
    try app.register(collection: AnchorController())
}
