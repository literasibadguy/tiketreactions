import Foundation
import Argo

public enum SwishError {
  case argoError(Argo.DecodeError)
  case deserializationError(Error)
  case parseError(Error)
  case serverError(code: Int, data: Data?)
  case urlSessionError(Error)
}

extension SwishError: Error { }

extension SwishError: CustomNSError {
  public static let errorDomain = "com.thoughtbot.swish"

  public var errorCode: Int {
    switch self {
    case .argoError:
      return 1
    case .deserializationError:
      return 2
    case .parseError:
      return 3
    case .serverError:
      return 4
    case .urlSessionError:
      return 5
    }
  }

#if !swift(>=3.1)
  public var errorUserInfo: [String: Any] {
    var userInfo: [String: Any] = [:]
    userInfo[NSLocalizedDescriptionKey] = errorDescription
    return userInfo
  }
#endif
}

extension SwishError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case let .serverError(code, _):
      return message(forStatus: code)

    case let .deserializationError(error),
         let .parseError(error),
         let .urlSessionError(error):
      return (error as? LocalizedError)?.errorDescription

    case let .argoError(localizedError as LocalizedError):
      return localizedError.errorDescription

    case let .argoError(error):
      return String(describing: error)
    }
  }
}

private func message(forStatus code: Int) -> String {
  switch code {
  case 300...399:
    return "Multiple choices: \(code)"
  case 400...499:
    return "Bad request: \(code)"
  case 500...599:
    return "Server error: \(code)"
  default:
    return "Unknown error: \(code)"
  }
}
