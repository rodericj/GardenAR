import Fluent

struct CreateAnchor: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Anchor.schema)
            .id()
            .field("title", .string, .required)
            .field("world_id", .uuid, .required, .references("world", "id"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Anchor.schema).delete()
    }
}
