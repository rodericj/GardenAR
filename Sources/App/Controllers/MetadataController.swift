import Fluent
import Vapor

struct NewMetadata: Content {
    let text: String
    let type: MetadataType
}
enum MetadataError: Error {
    case anchorNotFound
}

struct MetadataController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let metadata = routes.grouped("metadata")
        metadata.get(use: index)
        
        metadata.group(":metadataID") { metadata in
            metadata.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[AnchorMetadata]> {
        return AnchorMetadata.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<AnchorMetadata> {

        let metadata = try req.content.decode(NewMetadata.self)
        return Anchor.find(req.parameters.get("anchorID"), on: req.db)
            .unwrap(or: MetadataError.anchorNotFound)
            .flatMap { anchor in
                let newMetaData = AnchorMetadata(text: metadata.text, type: metadata.type)
                return anchor.$metadata.create(newMetaData, on: req.db).map { newMetaData }
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return AnchorMetadata.find(req.parameters.get("metadataID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}

