import Fluent
import Vapor

struct WorldController: RouteCollection {
    let anchorController = AnchorController()
    func boot(routes: RoutesBuilder) throws {
        let worlds = routes.grouped("world")
        worlds.get(use: index)
        worlds.post(use: create)
        worlds.group(":worldID") { world in
            let anchors = world.grouped("anchor")
            anchors.post(use: anchorController.create)
            world.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[World]> {
        return World.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<World> {
        let world = try req.content.decode(World.self)
        return world.save(on: req.db).map { world }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return World.find(req.parameters.get("worldID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
