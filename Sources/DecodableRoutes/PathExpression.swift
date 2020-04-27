import Foundation
import Glide
import NIOHTTP1
import NIO

// TODO: Use in public API
public enum Transform<T> {
  case urlPath
  case urlQuery
  case bodyJSON
  case boydURLEncoded
  case custom((Request) throws -> T)
}

// MARK: - Glide PathExpression
extension Router {
  public func route<V: Decodable>(
    _ method: HTTPMethod = .GET,
    _ expression: PathExpression,
    transform: @escaping (Request) throws -> V,
    throwing: Bool = true,
    handler: @escaping (V) -> Middleware
  ) {
    use(
      Router.middleware(
        method,
        with: expression,
        transform: transform,
        throwing: throwing,
        handler: handler
      )
    )
  }

  // MARK: - HTTP Method Helpers
  public func get<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .GET,
      expression,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  public func post<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .POST,
      expression,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  public func put<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .PUT,
      expression,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }
  
  public func patch<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .PATCH,
      expression,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  public func delete<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .DELETE,
      expression,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  // MARK: Private
  static func middleware<T: URIMatching, V: Decodable>(
    _ method: HTTPMethod = .GET,
    with matcher: T,
    transform: @escaping (Request) throws -> V,
    throwing: Bool,
    handler: @escaping (V) -> Middleware
  ) -> Middleware {
    { request, response in
      guard match(method, request: request, matcher: matcher) else {
        return request.successFuture(.next)
      }

      if throwing {
        let decoded = try transform(request)
        return try handler(decoded)(request, response)
      } else {
        if let decoded = try? transform(request) {
          return try handler(decoded)(request, response)
        } else {
          return request.successFuture(.next)
        }
      }
    }
  }
}
