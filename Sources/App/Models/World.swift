import Fluent
import Vapor

struct ClientWorld: Content {
    var title: String
    func world() -> World {
        return World(title: title)
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
