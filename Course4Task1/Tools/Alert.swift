//
//  Alert.swift
//  Course4Task1
//
//  Created by Надежда Зенкова on 24.05.2020.
//  Copyright © 2020 Надежда Зенкова. All rights reserved.
//

import UIKit

class Alert {
    private let title: String?
    private let message: String?
    
    init(title: String?, message: String) {
        self.title = title
        self.message = message
    }
    
    func showAlert(in view: UIViewController, completion: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: completion)
        alertController.addAction(okAction)
        view.present(alertController, animated: true, completion: nil)
    }
    
}
