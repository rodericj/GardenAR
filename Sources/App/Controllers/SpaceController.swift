import Fluent
import Vapor

struct SpaceController: RouteCollection {
    let anchorController = AnchorController()
    func boot(routes: RoutesBuilder) throws {
        let spaces = routes.grouped("space")
        spaces.get(use: index)
        spaces.post(use: create)
        spaces.group(":spaceID") { space in
            // posting raw data
            space.on(.POST, body: .collect(maxSize: 100_000_000), use: saveData)
            space.get(use: fetchSingle)
            let anchors = space.grouped("anchor")
            anchors.post(use: anchorController.create)
            space.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[LiteSpace]> {
        let allSpaces = Space.query(on: req.db).with(\.$anchors).all().flatMapThrowing { spaces in
            try spaces.map { try LiteSpace(space: $0) }
        }
        return allSpaces
    }

    func create(req: Request) throws -> EventLoopFuture<Space> {
        let clientSpace = try req.content.decode(ClientSpace.self)
        let space =  clientSpace.space()
        return space.save(on: req.db).map { space }
    }

    func fetchSingle(req: Request) throws -> EventLoopFuture<Space> {
        return Space.find(req.parameters.get("spaceID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Space.find(req.parameters.get("spaceID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }

    func saveData(_ req: Request) throws -> EventLoopFuture<Anchor> {
        return try anchorController.create(req: req)
    }
}
