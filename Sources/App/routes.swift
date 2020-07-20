import Fluent
import Vapor
func routes(_ app: Application) throws {
    try app.register(collection: SpaceController())
    try app.register(collection: AnchorController())
}
