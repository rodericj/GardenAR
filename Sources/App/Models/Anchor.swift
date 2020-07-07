import Fluent
import Vapor

final class Anchor: Model, Content {
    static let schema = "anchor"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Parent(key: "world_id")
    var world: World

    @Children(for: \.$anchor)
    var metadata: [AnchorMetadata]

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
