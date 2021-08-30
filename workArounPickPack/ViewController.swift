//
//  ViewController.swift
//  workArounPickPack
//
//  Created by Daryna Polevyk on 28.08.2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    private lazy var superView = UIView()
    let hiddenTF: CustomeTextField = CustomeTextField()
    private lazy var pinCodeLabel: UILabel = UILabel()
    var mask = ""
    var formatCode = Singleton.shared.formatCode

    private var pinCode: String = Singleton.shared.pinCode
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenKeyBoard()
        hiddenTF.customizeTF()
        selectCodeFormat()
        setUI()
        runSnapKitLayout()
        pinCodeLabel.text = formattedPinCode(code: pinCode)
        
        hiddenTF.delegate = self
        hiddenTF.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

extension ViewController {
    
    private func selectCodeFormat() {
        switch Singleton.shared.formatCode {
        case .sixNumbers: mask = "### ###"
        case .nineNumbers: mask = "### ### ###"
        case .eightNumbers: mask = "#### ####"
        }
    }
    
    private func listenKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setUI() {
        superView.backgroundColor = .blue
        self.view.addSubview(superView)
        self.view.addSubview(hiddenTF)
        setLabel()
        
    }
    
    private func setLabel() {
        pinCodeLabel.textColor = UIColor.black
        pinCodeLabel.textAlignment = NSTextAlignment.center
        pinCodeLabel.font = UIFont.systemFont(ofSize: 20)
        pinCodeLabel.textColor = .gray
        superView.addSubview(pinCodeLabel)
    }
    
    private func runSnapKitLayout() {
        superView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            
        }
        
        pinCodeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(superView).offset(300)
            make.width.equalTo(300)
            make.height.equalTo(100)
            make.leading.equalTo(50)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("Keyboard will show")
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        self.superView.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("Keyboard will hide:")
        self.superView.frame.origin.y = 0
    }
    
    private func switchText() -> String{
        let countText = hiddenTF.text?.count
        
        if formatCode == CodeFormat.nineNumbers{
            switch countText {
            case 0: pinCode = "000000000"
            case 1: pinCode = hiddenTF.text! + "000000000"
            case 2: pinCode = hiddenTF.text! + "0000000"
            case 3: pinCode = hiddenTF.text! + "000000"
            case 4: pinCode = hiddenTF.text! + "00000"
            case 5: pinCode = hiddenTF.text! + "0000"
            case 6: pinCode = hiddenTF.text! + "000"
            case 7: pinCode = hiddenTF.text! + "00"
            case 8: pinCode = hiddenTF.text! + "0"
            default:pinCode   = hiddenTF.text!
            }
        } else if formatCode == CodeFormat.sixNumbers {
            switch countText {
            case 0: pinCode = "000000"
            case 1: pinCode = hiddenTF.text! + "000000"
            case 2: pinCode = hiddenTF.text! + "0000"
            case 3: pinCode = hiddenTF.text! + "000"
            case 4: pinCode = hiddenTF.text! + "00"
            case 5: pinCode = hiddenTF.text! + "0"
            default: pinCode   = hiddenTF.text!
            }
        } else if formatCode == CodeFormat.eightNumbers {
            switch countText {
            case 0: pinCode = "00000000"
            case 1: pinCode = hiddenTF.text! + "0000000"
            case 2: pinCode = hiddenTF.text! + "000000"
            case 3: pinCode = hiddenTF.text! + "00000"
            case 4: pinCode = hiddenTF.text! + "0000"
            case 5: pinCode = hiddenTF.text! + "000"
            case 6: pinCode = hiddenTF.text! + "00"
            case 7: pinCode = hiddenTF.text! + "0"
            default: pinCode  = hiddenTF.text!
            }
        }
        Singleton.shared.pinCode = pinCode
        return pinCode
    }
    
    @objc func  textFieldDidChange(sender: UITextField) {
        hiddenTF.checkMaxLength(maxLength: formatCode.rawValue)
        let text = switchText()
        pinCodeLabel.text = formattedPinCode(code: text)
    }
    
    private func formattedPinCode(code: String) -> String {
        
        let cleanPinCode = code.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = cleanPinCode.startIndex
        for ch in mask where index < cleanPinCode.endIndex {
            if ch == "#" {
                result.append(cleanPinCode[index])
                index = cleanPinCode.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func changeColorText(text: String) {
        let range = (text as! NSString).range(of: hiddenTF.text!)
        let attributedString = NSMutableAttributedString(string:hiddenTF.text!)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        pinCodeLabel.attributedText = attributedString
    }
    
}

