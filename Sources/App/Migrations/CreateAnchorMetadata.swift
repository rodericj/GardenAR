import Fluent

struct CreateAnchorMetadata: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return  database.enum("MetadataType")
            .case("note")
            .case("url")
            .create()
            .flatMap
            { metadataEnum in
                database.schema(AnchorMetadata.schema)
                    .id()
                    .field("text", .string, .required)
                    .field("type", metadataEnum, .required)
                    .field("anchor_id", .uuid, .required, .references("anchor", "id"))
                    .create()
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(AnchorMetadata.schema).delete()
    }
}
