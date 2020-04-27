import Glide

public enum DecodableRouteError: AbortError {
  case missingRequestBody
  case wrongContentType

  public var status: HTTPResponseStatus {
    switch self {
    case .missingRequestBody,
         .wrongContentType:
      return .internalServerError
    }
  }

  public var errorDescription: String? {
    return self.description
  }

  public var description: String {
    reason
  }

  public var reason: String {
    switch self {
    case .missingRequestBody:
      return "Missing request body."
    case .wrongContentType:
      return "Wrong request Content-Type."
    }
  }
}
