//
//  NetworkConfig.swift
//  Posts
//
//  Created by M-M-M on 14/03/2025.
//

import Foundation
import Alamofire

protocol NetworkConfigurable {
    var baseURL: String { get }
    var headers: [String: String] { get }
    var parameters: Parameters { get }
}

struct ApiDataNetworkConfig: NetworkConfigurable {
    let baseURL: String
    let headers: [String: String]
    let parameters: Parameters
    
     init(
        baseURL: String,
        headers: [String: String] = [:] ,
        parameters: Parameters = [:]) {
        self.baseURL = baseURL
        self.headers = headers
        self.parameters = parameters
    }
}
