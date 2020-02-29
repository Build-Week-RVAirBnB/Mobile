//
//  LoginSwitch.swift
//  RVenture
//
//  Created by Joshua Rutkowski on 2/29/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit

class LoginSwitch: UISwitch {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = .white
        self.onTintColor = #colorLiteral(red: 0.4394537807, green: 0.449608624, blue: 0.1603180766, alpha: 1)
        self.addTarget(self, action: #selector(handleSwitch), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handleSwitch() {
        if self.isOn {
            print("Switch ON")
        } else {
            print("Switch OFF")
        }
    }
    
}
