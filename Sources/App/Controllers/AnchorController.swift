import Fluent
import Vapor

struct AnchorDataPayload: Content {
    var anchorName: String
    var data: Data
    var id: UUID
}

enum AnchorError: Error {
    case worldNotFound
}
struct AnchorController: RouteCollection {
    let metadataController = MetadataController()
    func boot(routes: RoutesBuilder) throws {
        let anchors = routes.grouped("anchor")
        anchors.get(use: index)
        anchors.group(":anchorID") { anchor in
            let metadata = anchor.grouped("metadata")
            metadata.post(use: metadataController.create)
            anchor.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Anchor]> {
        return Anchor.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Anchor> {

        let anchor = try req.content.decode(AnchorDataPayload.self)
        print("We got a new anchor in the anchor controller. It's UUID = \(anchor.id)")
        return World.find(req.parameters.get("worldID"), on: req.db)
            .unwrap(or: AnchorError.worldNotFound)
            .flatMap { world in
                world.data = anchor.data
                let newAnchor = Anchor(id: anchor.id, title: anchor.anchorName)
                let createAnchor = world.$anchors.create(newAnchor, on: req.db)
                return world.save(on: req.db).and(createAnchor).map { _ in newAnchor }
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Anchor.find(req.parameters.get("worldID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}

