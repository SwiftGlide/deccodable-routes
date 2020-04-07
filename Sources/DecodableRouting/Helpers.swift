import Glide

public func decodePath<T: Decodable>(
  _ decoder: JSONDecoder = JSONDecoder()
) -> (Request) -> T? {
  { request in
    guard let json = request.pathParameters.JSONData else { return nil }
    return try? decoder.decode(T.self, from: json)
  }
}

public func decodeQuery<T: Decodable>(
  _ decoder: JSONDecoder = JSONDecoder()
) -> (Request) -> T? {
  { request in
    guard let json = request.queryParameters.JSONData else { return nil }
    return try? decoder.decode(T.self, from: json)
  }
}
