import Fluent
import Vapor

struct NewAnchor: Content {
    let title: String
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

        let anchor = try req.content.decode(NewAnchor.self)
        return World.find(req.parameters.get("worldID"), on: req.db)
            .unwrap(or: AnchorError.worldNotFound)
            .flatMap { world in
                let newAnchor = Anchor(title: anchor.title)
                return world.$anchors.create(newAnchor, on: req.db).map { newAnchor }
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Anchor.find(req.parameters.get("worldID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}

