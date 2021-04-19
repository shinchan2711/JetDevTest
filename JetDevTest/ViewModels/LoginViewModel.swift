//
//  LoginViewModel.swift
//  JetDevTest
//
//  Created by Vanessa Jane on 4/19/21.
//  Copyright © 2021 Vanessa Jane. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftUtilities

class LoginViewModel: ViewModelProtocol {
    struct Input {
        let email: AnyObserver<String>
        let password: AnyObserver<String>
        let loginDidTap: AnyObserver<Void>
    }
    struct Output {
        let loginResultObservable: Observable<AutenticationStatus>
        let errorsObservable: Observable<Error>
    }
    
    let input: Input
    let output: Output
    private let emailSubject = PublishSubject<String>()
    private let passwordSubject = PublishSubject<String>()
    private let  loginButtonDidTap = PublishSubject<Void>()
    
    private let loginResultSubject = PublishSubject<AutenticationStatus>()
    private let errorsSubject = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    
    private var credentialsObservable: Observable<Credentials> {
        return Observable.combineLatest(emailSubject.asObservable(), passwordSubject.asObservable()) { (email, password) in
            return Credentials(email: email, password: password)
        }
    }
    
    var activityIndicator: ActivityIndicator
    init(authService: AuthProtocol) {
        let ac = ActivityIndicator()
        activityIndicator = ac
        
        input = Input(email: emailSubject.asObserver(),
                      password: passwordSubject.asObserver(),
                      loginDidTap: loginButtonDidTap.asObserver())
        
        output = Output(loginResultObservable: loginResultSubject.asObservable(),
                        errorsObservable: errorsSubject.asObservable())
        
        
        loginButtonDidTap
            .withLatestFrom(credentialsObservable)
            .flatMapLatest { credentials in
                return authService.login(with: credentials).materialize()
                    .trackActivity(ac)
            }
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .next(let json):
                    print(json)
                    //TODO: show the results
//                    self?.loginResultSubject.onNext(autenticationStatus)
                case .error(let error):
                    self?.errorsSubject.onNext(error)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
}




