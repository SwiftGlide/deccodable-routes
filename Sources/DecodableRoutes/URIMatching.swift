import Glide

extension Router {
  public func route<T: URIMatching, V: Decodable>(
    _ method: HTTPMethod = .GET,
    _ uriMatcher: T,
    transform: @escaping (Request) throws -> V,
    throwing: Bool = true,
    handler: @escaping (V) -> Middleware
  ) {
    use(
      Router.middleware(
        method,
        with: uriMatcher,
        transform: transform,
        throwing: throwing,
        handler: handler
      )
    )
  }

  // MARK: - HTTP Method Helpers
  // MARK: Get
  public func get<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .GET,
      uriMatcher,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  // MARK: Post
  public func post<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .POST,
      uriMatcher,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  // MARK: Put
  public func put<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .PUT,
      uriMatcher,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  // MARK: Patch
  public func patch<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .PATCH,
      uriMatcher,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }

  // MARK: Delete
  public func delete<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) throws -> V,
    fallsThrough: Bool = false,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .DELETE,
      uriMatcher,
      transform: transform,
      throwing: !fallsThrough,
      handler: handler
    )
  }
}
