//
//  LoginViewController.swift
//  JetDevTest
//
//  Created by Vanessa Jane on 4/19/21.
//  Copyright © 2021 Vanessa Jane. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

class LoginViewController: UIViewController {
    // MARK: - Properties
    var loginViewModel: LoginViewModel!
    let disposeBag = DisposeBag()
    let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginErrorDescriptionLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = LoginViewModel(authService: LoginService.sharedManager)
        
        setupButton()
        bindData()
        // Do any additional setup after loading the view.
    }
    
    func setupButton() {
        loginButton.layer.cornerRadius = 5
    }
    
    
//    func highlightTextField(_ textField: UITextField?) {
//        textField?.resignFirstResponder()
//        textField?.layer.borderWidth = 1.0
//        textField?.layer.borderColor = UIColor.red.cgColor
//        textField?.layer.cornerRadius = 3
//    }
//
    
    
    //MARK: - Bind data
    func bindData() {
        emailTextField.rx.text.asObservable()
            .ignoreNil()
            .subscribe(loginViewModel.input.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.asObservable()
            .ignoreNil()
            .subscribe(loginViewModel.input.password)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap.asObservable()
            .subscribe(loginViewModel.input.loginDidTap)
            .disposed(by: disposeBag)
        
        loginViewModel.output.errorsObservable
            .subscribe(onNext: { [unowned self] (error) in
                self.presentError(error)
            })
            .disposed(by: disposeBag)
        
        loginViewModel.output.loginResultObservable
            .subscribe(onNext: { [unowned self] (user) in
                self.presentMessage("User successfully signed in!")
            })
            .disposed(by: disposeBag)
        
        loginViewModel
            .activityIndicator.asDriver()
            .debug()
            .distinctUntilChanged()
            .drive(onNext: { active in
                if (active){
                    MBProgressHUD.showAdded(to: ((UIApplication.shared.delegate?.window)!)!, animated: true)
                } else {
                    MBProgressHUD.hide(for:((UIApplication.shared.delegate?.window)!)!, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
}

