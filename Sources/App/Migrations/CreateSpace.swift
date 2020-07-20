import Fluent

struct CreateSpace: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Space.schema)
            .id()
            .field("title", .string, .required)
            .field("data", .data)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Space.schema).delete()
    }
}
