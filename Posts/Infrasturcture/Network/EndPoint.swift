//
//  EndPoint.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import Foundation
import Alamofire

protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var encoding: ParameterEncoding? { get }
    var parameters: Parameters { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) -> DataRequest?
}

class Endpoint: Requestable {
    let path: String
    let isFullPath: Bool
    let method: HTTPMethod
    var headers: [String: String]
    let encoding: ParameterEncoding?
    var parameters: Parameters
    
    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethod,
         headers: [String: String] = [:],
         encoding: ParameterEncoding? = nil,
         parameters: Parameters = [:]) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headers = headers
        self.encoding = encoding
        self.parameters = parameters
    }
}

extension Endpoint {
    func urlRequest(with config: NetworkConfigurable) -> DataRequest? {
        let urlPath = isFullPath ? path : config.baseURL + path
        guard let url = URL(string: urlPath) else { return nil }
    
        return AF.request(url,
                          method: method,
                          parameters: getParameters(with: config.parameters),
                          encoding: encoding ?? URLEncoding.default,
                          headers: getHeaders(with: config.headers))
    }
    
    private func getParameters(with configParameters: Parameters) -> Parameters {
        var allParameters = configParameters
        parameters.forEach { allParameters.updateValue($1, forKey: $0) }
        return allParameters
    }
    
    private func getHeaders(with configHeaders: [String: String]) -> HTTPHeaders {
        var allHeaders: [String: String] = configHeaders
        headers.forEach { allHeaders.updateValue($1, forKey: $0) }
        return HTTPHeaders(allHeaders)
    }
}
