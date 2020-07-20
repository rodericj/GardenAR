import Fluent

struct CreateAnchor: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Anchor.schema)
            .id()
            .field("title", .string, .required)
            .field("space_id", .uuid, .required, .references("space", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Anchor.schema).delete()
    }
}
