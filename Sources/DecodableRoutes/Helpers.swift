import Glide
import QueryStringCoder

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

public func decodeURLEncodedForm<T: Decodable>(
  _ decoder: QueryStringDecoder = .init()
) -> (Request) throws -> T {
  { request in
    guard let contentType = request.head.headers["Content-Type"].first,
          let mimeType = MIMEType(contentType),
          Set([.formURLEncoded]).contains(mimeType) else {
      throw DecodableRouteError.wrongContentType
    }
    guard let data = request.body else {
      throw DecodableRouteError.missingRequestBody
    }
    return try decoder.decode(T.self, from: data)
  }
}
