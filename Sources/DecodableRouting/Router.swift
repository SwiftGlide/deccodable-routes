import Foundation
import Glide
import NIOHTTP1
import NIO

// MARK: - Glide PathExpression
extension Router {
  public func route<V: Decodable>(
    _ method: HTTPMethod = .GET,
    _ expression: PathExpression,
    transform: @escaping (Request) -> V? = decodePath(),
    handler: @escaping (V) -> Middleware
  ) {
    use(
      Router.middleware(
        method,
        with: expression,
        transform: transform,
        handler: handler
      )
    )
  }

  public func route<V: Decodable>(
    _ method: HTTPMethod = .GET,
    _ expression: PathExpression,
    transform: @escaping (Request) throws -> V,
    handler: @escaping (V) -> Middleware
  ) {
    use(
      Router.middleware(
        method,
        with: expression,
        transform: transform,
        handler: handler
      )
    )
  }

  // MARK: - HTTP Method Helpers
  // MARK: Get
  public func get<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) -> V? = decodePath(),
    handler: @escaping (V) -> Middleware
  ) {
    route(.GET, expression, transform: transform, handler: handler)
  }

  public func get<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) throw -> V,
    handler: @escaping (V) -> Middleware
  ) {
    route(.GET, expression, transform: transform, handler: handler)
  }

  // MARK: Post
  public func post<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) -> V? = decodePath(),
    handler: @escaping (V) -> Middleware
  ) {
    route(.POST, expression, transform: transform, handler: handler)
  }

  // MARK: Put
  public func put<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) -> V? = decodePath(),
    handler: @escaping (V) -> Middleware
  ) {
    route(.PUT, expression, transform: transform, handler: handler)
  }

  // MARK: Patch
  public func patch<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) -> V? = decodePath(),
    handler: @escaping (V) -> Middleware
  ) {
    route(.PATCH, expression, transform: transform, handler: handler)
  }

  // MARK: Delete
  public func delete<V: Decodable>(
    _ expression: PathExpression,
    transform: @escaping (Request) -> V? = decodePath(),
    handler: @escaping (V) -> Middleware
  ) {
    route(.DELETE, expression, transform: transform, handler: handler)
  }

  // MARK: Private
  private static func middleware<T: URIMatching, V: Decodable>(
    _ method: HTTPMethod = .GET,
    with matcher: T,
    transform: @escaping (Request) -> V? = decodePath(),
    handler: @escaping (V) -> Middleware
  ) -> Middleware {
    { request, response in
      guard match(method, request: request, matcher: matcher) else {
        return .next
      }

      guard let value = transform(request) else {
        return .next
      }

      return try handler(value)(request, response)
    }
  }

  private static func middleware<T: URIMatching, V: Decodable>(
    _ method: HTTPMethod = .GET,
    with matcher: T,
    transform: @escaping (Request) throws -> V,
    handler: @escaping (V) -> Middleware
  ) -> Middleware {
    { request, response in
      guard match(method, request: request, matcher: matcher) else {
        return .next
      }

      let value = try transform(request)
      return try handler(value)(request, response)
    }
  }
}

// MARK: - Custom URI Matcher
extension Router {
  public func route<T: URIMatching, V: Decodable>(
    _ method: HTTPMethod = .GET,
    _ uriMatcher: T,
    transform: @escaping (Request) throws -> V,
    handler: @escaping (V) -> Middleware
  ) {
    use(
      Router.middleware(
        method,
        with: uriMatcher,
        transform: transform,
        handler: handler
      )
    )
  }

  public func route<T: URIMatching, V: Decodable>(
    _ method: HTTPMethod = .GET,
    _ uriMatcher: T,
    transform: @escaping (Request) -> V? = decodePath(),
    handler: @escaping (V) -> Middleware
  ) {
    use(
      Router.middleware(
        method,
        with: uriMatcher,
        transform: transform,
        handler: handler
      )
    )
  }

  // MARK: - HTTP Method Helpers
  // MARK: Get
  public func get<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) -> V? = decodePath(),
    handler: @escaping (V) -> Middleware
  ) {
    route(.GET, uriMatcher, transform: transform, handler: handler)
  }

  // MARK: Post
  public func post<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) -> V? = decodePath(),
    handler: @escaping (V) -> Middleware
  ) {
    route(.POST, uriMatcher, transform: transform, handler: handler)
  }

  // MARK: Put
  public func put<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) -> V? = decodePath(),
    handler: @escaping (V) -> Middleware
  ) {
    route(.PUT, uriMatcher, transform: transform, handler: handler)
  }

  // MARK: Patch
  public func patch<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) -> V? = decodePath(),
    handler: @escaping (V) -> Middleware
  ) {
    route(.PATCH, uriMatcher, transform: transform, handler: handler)
  }

  // MARK: Delete
  public func delete<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) -> V? = decodePath(),
    handler: @escaping (V) -> Middleware
  ) {
    route(.DELETE, uriMatcher, transform: transform, handler: handler)
  }
}
