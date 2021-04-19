//
//  UIViewController+Extensions.swift
//  JetDevTest
//
//  Created by Vanessa Jane on 4/19/21.
//  Copyright © 2021 Vanessa Jane. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentError(_ error: Error) {
        let alertController = UIAlertController(title: "Error!",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    func presentMessage(_ message: String) {
        let alertController = UIAlertController(title: "",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
}
