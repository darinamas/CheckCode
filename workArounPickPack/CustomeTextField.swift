//
//  TextField.swift
//  workArounPickPack
//
//  Created by Daryna Polevyk on 28.08.2021.
//

import UIKit

class CustomeTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
            
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customizeTF() {
        self.frame = CGRect(x: 20, y: 20, width: 100, height: 200)
        self.backgroundColor = .red
        self.becomeFirstResponder()
        self.keyboardType = UIKeyboardType.numberPad
    
    }
    
     func checkMaxLength(maxLength: Int) {
        if self.text!.count > maxLength {
            self.deleteBackward()
        }
    }
    
    
 
   
    
}
