//
//  LoginService.swift
//  JetDevTest
//
//  Created by Vanessa Jane on 4/19/21.
//  Copyright © 2021 Vanessa Jane. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya

enum AutenticationError: Error {
    case server
    case badReponse(String)
    case badCredentials
}

enum AutenticationStatus {
    case none
    case error(AutenticationError)
    case success(String)
}

protocol AuthProtocol {
    func login(with credentials:Credentials)-> Observable<Any>
}

class LoginService:AuthProtocol {
    static var sharedManager = LoginService()
    private let provider = MoyaProvider<Service>()
    
    fileprivate init() {}
    

    func login(with credentials: Credentials)->Observable<Any> {
        return provider.rx
            .request(.login(email: credentials.email, password: credentials.password))
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
            .asObservable()
    }
}
