import AsyncHTTPClient
import XCTest
import Glide
@testable import DecodableRoutes

let testPort = 8170

struct Post: Codable {
  var categoryID: Int
  var slug: String
}

final class DecodableRouteTests: XCTestCase {
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
  }

  func performHTTPTest(_ test: (_ app: Application, _ client: HTTPClient) throws -> Void) {
    let app = Application(.testing)
    app.listen(testPort)
    defer { app.shutdown() }

    let client = HTTPClient(eventLoopGroupProvider: .createNew)
    defer { try! client.syncShutdown() }

    do {
      try test(app, client)
    } catch {
      XCTFail("Could not run the test.")
    }
  }

  func testPathDecodingSuccess() throws {
    let expectation = XCTestExpectation()

    performHTTPTest { app, client in
      app.get("/\("categoryID", as: Int.self)/\("slug")", transform: decodePath()) { (post: Post) in
        XCTAssertEqual(post.categoryID, 99)
        XCTAssertEqual(post.slug, "my-post")

        expectation.fulfill()

        return { _, response in
          response.json(post)
        }
      }

      app.get("\(wildcard: .all)") { request, response in
        XCTFail("The path expression didn't match the provided URL.")
        expectation.fulfill()
        return response.send("Oops")
      }

      let request = try HTTPClient.Request(
        url: "http://localhost:\(testPort)/99/my-post",
        method: .GET,
        headers: .init()
      )

      _ = try client.execute(request: request).wait()
    }

    wait(for: [expectation], timeout: 5)
  }

  func testPathDecodingFailure() throws {
    let expectation = XCTestExpectation()

    performHTTPTest { app, client in
      app.get("/\("categoryID", as: Int.self)/\("slug")", transform: decodeQuery()) { (post: Post) in
        { _, response in
          response.json(post)
        }
      }

      app.get("\(wildcard: .all)") { request, response in
        response.send("Oops")
      }

      let request = try HTTPClient.Request(
        url: "http://localhost:\(testPort)/foo/my-post",
        method: .GET,
        headers: .init()
      )

      let response = try client.execute(request: request).wait()

      var buffer = response.body ?? ByteBufferAllocator().buffer(capacity: 0)
      let responseContent = buffer.readString(length: buffer.readableBytes) ?? ""

      XCTAssertEqual(responseContent, "Oops")
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 5)
  }

  func testQueryDecodingSuccess() throws {
     let expectation = XCTestExpectation()

     performHTTPTest { app, client in
      app.get("/post?\("categoryID", as: Int.self)&\("slug")", transform: decodeQuery()) { (post: Post) in
         XCTAssertEqual(post.categoryID, 99)
         XCTAssertEqual(post.slug, "my-post")

         expectation.fulfill()

         return { _, response in
          response.json(post)
         }
       }

      app.get("\(wildcard: .all)") { request, response in
        XCTFail("The path expression didn't match the provided URL.")
        expectation.fulfill()
        return response.send("Oops")
      }

       let request = try HTTPClient.Request(
         url: "http://localhost:\(testPort)/post?slug=my-post&categoryID=99",
         method: .GET,
         headers: .init()
       )

       _ = try client.execute(request: request).wait()
     }

     wait(for: [expectation], timeout: 5)
   }

   func testQueryDecodingFailure() throws {
     let expectation = XCTestExpectation()

     performHTTPTest { app, client in
       app.get("/post", transform: decodeQuery()) { (post: Post) in
         { _, response in
          response.json(post)
         }
       }

       app.get("\(wildcard: .all)") { request, response in
        response.send("Oops")
       }

       let request = try HTTPClient.Request(
         url: "http://localhost:\(testPort)/post?categoryID=89",
         method: .GET,
         headers: .init()
       )

       let response = try client.execute(request: request).wait()

      XCTAssertEqual(response.status, .badRequest)
       expectation.fulfill()
     }

     wait(for: [expectation], timeout: 5)
   }

  func testURLEncodedFormDecodingSuccess() throws {
    let expectation = XCTestExpectation()

    performHTTPTest { app, client in
     app.post("/post", transform: decodeURLEncodedForm()) { (post: Post) in
        XCTAssertEqual(post.categoryID, 99)
        XCTAssertEqual(post.slug, "my-post")

        expectation.fulfill()

        return { _, response in
         response.json(post)
        }
      }

     app.get("\(wildcard: .all)") { request, response in
       XCTFail("The path expression didn't match the provided URL.")
       expectation.fulfill()
       return response.send("Oops")
     }

      let request = try HTTPClient.Request(
        url: "http://localhost:\(testPort)/post",
        method: .POST,
        headers: .init([("Content-Type", "x-www-form-urlencoded")]),
        body: .string("slug=my-post&categoryID=99")
      )

      _ = try client.execute(request: request).wait()
    }

    wait(for: [expectation], timeout: 5)
  }
}
