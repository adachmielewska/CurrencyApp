//
//  WebRespository.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 01/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
import Combine
import Alamofire

protocol WebRepository {
    func call<Value: Decodable>(endpoint: URLRequestElement) -> AnyPublisher<Value, Error>
}

enum NetworkError: Swift.Error {
    case errorStatusCode(code: Int)
    case invalidURL
    case missingAuthorization
    case unknown
}

protocol AuthorizationHandler {
    func sign(request: URLRequest) throws -> URLRequest?
}

struct Authorizer: AuthorizationHandler {
    let apiKey: String

    func sign(request: URLRequest) throws -> URLRequest? {
        guard let url = request.urlRequest else { return request.urlRequest }
        return try URLEncoding().encode(url, with: ["appid" : apiKey])
    }
}

struct RealWebRepository: WebRepository {
    let session: Session
    let baseURL: URL
    let authorizer: AuthorizationHandler?

    init(session: URLSession, baseURL: URL, authorizer: AuthorizationHandler?) {
        self.session = Session(configuration: session.configuration)
        self.baseURL = baseURL
        self.authorizer = authorizer
    }

    func call<Value>(endpoint: URLRequestElement) -> AnyPublisher<Value, Error> where Value : Decodable {
        do {
            let signedRequest = try prepareRequest(for: endpoint)
            return session.request(signedRequest).publishDecodable(type: Value.self).value()
                .mapError { error in
                    NetworkError.unknown
            }.eraseToAnyPublisher()
        } catch let error {
            return Fail<Value, Error>(error: error)
                .eraseToAnyPublisher()
        }
    }

    private func prepareRequest(for endpoint: URLRequestElement) throws -> URLRequest {
        let urlRequest = try endpoint.createUrlRequest(baseUrl: baseURL)
        let signedRequest = try authorizer?.sign(request: urlRequest) ?? urlRequest
        return signedRequest
    }
}
