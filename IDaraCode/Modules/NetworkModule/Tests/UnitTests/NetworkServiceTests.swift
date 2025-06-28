//
//  NetworkServiceTests.swift
//  iOSNativeProject
//
//  Created by Christian Martinez on 18/06/25.
//

import XCTest
@testable import iOSNativeProject

final class NetworkServiceTests: XCTestCase {

    private var stubEndpoint: Endpoint {
        Endpoint(path: "/contacts", method: .GET, body: nil, token: nil, queryParams: nil)
    }

    func test_performRequest_decodesSuccess() async throws {
        let json = #"{"name":"Chris"}"#.data(using: .utf8)!
        let response200 = HTTPURLResponse(url: URL(string:"https://mock/contacts")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)!

        let session = MockURLSession()
        session.nextData     = json
        session.nextResponse = response200

        let env      = MockEnvironment(baseURL: "https://mock")
        let builder  = RequestBuilder(environment: env)
        let sut      = NetworkService(requestBuilder: builder,
                                      responseHandler: ResponseHandler(),
                                      session: session)

        let result: ServiceResponse<ContactStub> =
            await sut.performRequest(for: stubEndpoint, decodingType: ContactStub.self)

        if case .success(let dto) = result {
            XCTAssertEqual(dto, ContactStub(name: "Chris"))
        } else {
            XCTFail("Expected success, \(result)")
        }
    }

    func test_performRequest_404() async {
        let response404 = HTTPURLResponse(url: URL(string:"https://mock/contacts")!,
                                          statusCode: 404, httpVersion: nil,
                                          headerFields: nil)!

        let session = MockURLSession()
        session.nextData     = Data()
        session.nextResponse = response404

        let env     = MockEnvironment(baseURL: "https://mock")
        let builder = RequestBuilder(environment: env)
        let sut     = NetworkService(requestBuilder: builder,
                                     responseHandler: ResponseHandler(),
                                     session: session)

        let result: ServiceResponse<Data> =
            await sut.performRequest(for: stubEndpoint, decodingType: Data.self)

        if case .failed(let err) = result {
            XCTAssertEqual(err.errorType, .notFound)
        } else {
            XCTFail("Expected 404 failure")
        }
    }
}
