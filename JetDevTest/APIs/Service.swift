//
//  Service.swift
//  JetDevTest
//
//  Created by Vanessa Jane on 4/19/21.
//  Copyright © 2021 Vanessa Jane. All rights reserved.
//

import Foundation
import Moya

enum Service {
    case login(email:String, password:String)
    
}


extension Service: TargetType {
    
    // This is the base URL we'll be using, typically our server.
    var baseURL: URL {
        return URL(string: "http://imaginato.mocklab.io")!
    }
    
    // This is the path of each operation that will be appended to our base URL.
    var path: String {
        switch self {
        case .login:
            return "/login"
        }
    }
    
    // Here we specify which method our calls should use.
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    // Here we specify body parameters, objects, files etc.
    var task: Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(parameters: ["email": email, " ": password], encoding: JSONEncoding.default)
        }
    }
    
    // These are the headers that our service requires.
    // Usually you would pass auth tokens here.
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    
    var sampleData: Data {
        return Data()
    }
    
}
