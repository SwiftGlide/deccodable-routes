import Glide



public func decodePath<T: Decodable>(
  _ decoder: JSONDecoder = JSONDecoder()
) -> (Request) throws -> T {
  { request in
    let json = try request.pathParameters.JSONData()
    return try decoder.decode(T.self, from: json)
  }
}

public func decodeQuery<T: Decodable>(
  _ decoder: JSONDecoder = JSONDecoder()
) -> (Request) throws -> T {
  { request in
    let json = try request.queryParameters.JSONData()
    return try decoder.decode(T.self, from: json)
  }
}

public func decodeBody<T: Decodable>(
  _ decoder: JSONDecoder = JSONDecoder()
) -> (Request) throws -> T {
  { request in
    guard let json = request.body else {
      throw DecodableRouteError.missingRequestBody
    }
    return try decoder.decode(T.self, from: json)
  }
}

