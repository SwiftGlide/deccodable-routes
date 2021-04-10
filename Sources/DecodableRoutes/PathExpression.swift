import Foundation
import Glide
import NIOHTTP1
import NIO

// TODO: Use in public API
public enum Strategy {
  case urlPath
  case urlQuery
  case bodyJSON
  case bodyURLEncoded

  func transform<T: Decodable>(_ type: T.Type) -> (Request) throws -> T {
    switch self {
    case .urlPath:
      return decodePath()
    case .urlQuery:
      return decodeQuery()
    case .bodyJSON:
      return decodeBody()
    case .bodyURLEncoded:
      return decodeURLEncodedForm()
    }
  }
}

// MARK: - Glide PathExpression
extension Router {
  public func route<V: Decodable>(
    _ method: HTTPMethod = .GET,
    _ expression: PathExpression,
    transform: @escaping (Request) throws -> V,
    throwing: Bool = true,
    handler: @escaping (V) -> ThrowingMiddleware
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

  public func route<V: Decodable>(
    _ method: HTTPMethod = .GET,
    _ expression: PathExpression,
    strategy: Strategy,
    throwing: Bool = true,
    handler: @escaping (V) -> ThrowingMiddleware
  ) {
    route(
      method,
      expression,
      transform: strategy.transform(V.self),
      throwing: throwing,
      handler: handler
    )
  }

  // MARK: - HTTP Method Helpers
  public func get<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> ThrowingMiddleware
  ) {
    route(
      .GET,
      expression,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  public func get<V: Decodable>(
    _ expression: PathExpression,
    _ strategy: Strategy,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> ThrowingMiddleware
  ) {
    route(
      .GET,
      expression,
      strategy: strategy,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  public func post<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> ThrowingMiddleware
  ) {
    route(
      .POST,
      expression,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  public func post<V: Decodable>(
    _ expression: PathExpression,
    _ strategy: Strategy,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> ThrowingMiddleware
  ) {
    route(
      .POST,
      expression,
      strategy: strategy,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  public func put<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> ThrowingMiddleware
  ) {
    route(
      .PUT,
      expression,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  public func put<V: Decodable>(
    _ expression: PathExpression,
    _ strategy: Strategy,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> ThrowingMiddleware
  ) {
    route(
      .PUT,
      expression,
      strategy: strategy,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  
  public func patch<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> ThrowingMiddleware
  ) {
    route(
      .PATCH,
      expression,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  public func patch<V: Decodable>(
    _ expression: PathExpression,
    _ strategy: Strategy,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> ThrowingMiddleware
  ) {
    route(
      .PATCH,
      expression,
      strategy: strategy,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  public func delete<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> ThrowingMiddleware
  ) {
    route(
      .DELETE,
      expression,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  public func delete<V: Decodable>(
    _ expression: PathExpression,
    _ strategy: Strategy,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> ThrowingMiddleware
  ) {
    route(
      .DELETE,
      expression,
      strategy: strategy,
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
    handler: @escaping (V) -> ThrowingMiddleware
  ) -> ThrowingMiddleware {
    { request, response in
      guard match(method, request: request, matcher: matcher) else {
        return request.success(.next)
      }

      if throwing {
        let decoded = try transform(request)
        return try handler(decoded)(request, response)
      } else {
        if let decoded = try? transform(request) {
          return try handler(decoded)(request, response)
        } else {
          return request.success(.next)
        }
      }
    }
  }
}
