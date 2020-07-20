import Fluent
import Vapor

struct ClientWorld: Content {
    var title: String
    func world() -> World {
        return World(title: title)
    }
}
struct LiteWorld: Content {
    var title: String
    var id: UUID
    var anchors: [Anchor]
    init(world: World) throws {
        title = world.title
        try id = world.requireID()
        anchors = world.anchors
    }
}
final class World: Model, Content {
    static let schema = "world"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @OptionalField(key: "data")
    var data: Data?

    @Children(for: \.$world)
    var anchors: [Anchor]

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
