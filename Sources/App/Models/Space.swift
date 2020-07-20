import Fluent
import Vapor

struct ClientSpace: Content {
    var title: String
    func space() -> Space {
        return Space(title: title)
    }
}
struct LiteSpace: Content {
    var title: String
    var id: UUID
    var anchors: [Anchor]
    init(space: Space) throws {
        title = space.title
        try id = space.requireID()
        anchors = space.anchors
    }
}
final class Space: Model, Content {
    static let schema = "space"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @OptionalField(key: "data")
    var data: Data?

    @Children(for: \.$space)
    var anchors: [Anchor]

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
