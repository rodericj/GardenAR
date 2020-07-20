import Fluent
import Vapor

struct WorldController: RouteCollection {
    let anchorController = AnchorController()
    func boot(routes: RoutesBuilder) throws {
        let worlds = routes.grouped("world")
        worlds.get(use: index)
        worlds.post(use: create)
        worlds.group(":worldID") { world in            
            // posting raw data
            world.on(.POST, body: .collect(maxSize: 100_000_000), use: saveData)
            world.get(use: fetchSingle)
            let anchors = world.grouped("anchor")
            anchors.post(use: anchorController.create)
            world.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[LiteWorld]> {
        let allWorlds = World.query(on: req.db).with(\.$anchors).all().flatMapThrowing { worlds in
            try worlds.map { try LiteWorld(world: $0) }
        }
        return allWorlds
    }

    func create(req: Request) throws -> EventLoopFuture<World> {
        let clientWorld = try req.content.decode(ClientWorld.self)
        let world =  clientWorld.world()
        return world.save(on: req.db).map { world }
    }

    func fetchSingle(req: Request) throws -> EventLoopFuture<World> {
        return World.find(req.parameters.get("worldID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return World.find(req.parameters.get("worldID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }

    func saveData(_ req: Request) throws -> EventLoopFuture<Anchor> {
        return try anchorController.create(req: req)
    }
}
