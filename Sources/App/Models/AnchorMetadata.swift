import Fluent
import Vapor

enum MetadataType: String, Codable {
    static let name = "METADATA_TYPE"
    case note, url
}

final class AnchorMetadata: Model, Content {
    static let schema = "anchormetadata"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "text")
    var text: String

    @Parent(key: "anchor_id")
    var anchor: Anchor

    @Enum(key: "type")
    var type: MetadataType

    init() { }

    init(id: UUID? = nil, text: String, type: MetadataType) {
        self.id = id
        self.text = text
        self.type = type
    }
}
