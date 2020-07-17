import Fluent

struct CreateWorld: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(World.schema)
            .id()
            .field("title", .string, .required)
            .field("data", .data)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(World.schema).delete()
    }
}
