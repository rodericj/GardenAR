import Fluent
import Vapor

final class World: Model, Content {
    static let schema = "world"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "data")
    var data: String

    @Children(for: \.$world)
    var anchors: [Anchor]

    init() { }

    init(id: UUID? = nil, title: String, data: String) {
        self.id = id
        self.title = title
        self.data = data
    }
}
