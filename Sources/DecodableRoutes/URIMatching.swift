import Glide

extension Router {
  public func route<T: URIMatching, V: Decodable>(
    _ method: HTTPMethod = .GET,
    _ uriMatcher: T,
    transform: @escaping (Request) throws -> V,
    throwDecodingError: Bool = true,
    handler: @escaping (V) -> Middleware
  ) {
    use(
      Router.middleware(
        method,
        with: uriMatcher,
        transform: transform,
        throwDecodingError: throwDecodingError,
        handler: handler
      )
    )
  }

  // MARK: - HTTP Method Helpers
  // MARK: Get
  public func get<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) throws -> V,
    throwDecodingError: Bool = true,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .GET,
      uriMatcher,
      transform: transform,
      throwDecodingError: throwDecodingError,
      handler: handler
    )
  }

  // MARK: Post
  public func post<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) throws -> V,
    throwDecodingError: Bool = true,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .POST,
      uriMatcher,
      transform: transform,
      throwDecodingError: throwDecodingError,
      handler: handler
    )
  }

  // MARK: Put
  public func put<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) throws -> V,
    throwDecodingError: Bool = true,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .PUT,
      uriMatcher,
      transform: transform,
      throwDecodingError: throwDecodingError,
      handler: handler
    )
  }

  // MARK: Patch
  public func patch<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) throws -> V,
    throwDecodingError: Bool = true,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .PATCH,
      uriMatcher,
      transform: transform,
      throwDecodingError: throwDecodingError,
      handler: handler
    )
  }

  // MARK: Delete
  public func delete<T: URIMatching, V: Decodable>(
    _ uriMatcher: T,
    transform: @escaping (Request) throws -> V,
    throwDecodingError: Bool = true,
    handler: @escaping (V) -> Middleware
  ) {
    route(
      .DELETE,
      uriMatcher,
      transform: transform,
      throwDecodingError: throwDecodingError,
      handler: handler
    )
  }
}
