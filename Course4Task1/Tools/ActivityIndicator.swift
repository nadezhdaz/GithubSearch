//
//  ActivityIndicator.swift
//  Course4Task1
//
//  Created by Надежда Зенкова on 24.05.2020.
//  Copyright © 2020 Надежда Зенкова. All rights reserved.
//

import UIKit

class ActitityIndicator: UIActivityIndicatorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        style = UIActivityIndicatorView.Style.whiteLarge
        alpha = 0.8
        hidesWhenStopped = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        UIApplication.shared.windows.first?.rootViewController?.view.addSubview(self)
    }
}
