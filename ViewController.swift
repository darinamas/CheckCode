//
//  ViewController.swift
//  workArounPickPack
//
//  Created by Daryna Polevyk on 28.08.2021.
//

import UIKit
import SnapKit

final class ViewController: UIViewController, UITextFieldDelegate {
    
    var viewModel: HomeViewViewModelType?
    private lazy var segmentcontols = UISegmentedControl()
    private lazy var superView = UIView()
    private lazy var hiddenTF: CustomeTextField = CustomeTextField()
    private lazy var pinCodeLabel: UILabel = UILabel()
    private lazy var pinCode: String = Singleton.shared.pinCode
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ViewControllerModelView() //delegat
        viewModel?.delegate = self  //delegatom dla vievModel budet vystupat MainViewController
        
        listenKeyBoard()
        viewModel?.codeFormatSelector()
        setUI()
        runSnapKitLayout()
       
        pinCodeLabel.text = viewModel?.maskPinCode(code: pinCode)
        hiddenTF.delegate = self
        
        hiddenTF.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

extension ViewController {
    
    private func listenKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setUI() {
        superView.backgroundColor = .white
        self.view.addSubview(superView)
        self.view.addSubview(hiddenTF)
        setLabel()
        hiddenTF.customizeTF()
        setSegmentContol()
    }
    
    private func setSegmentContol() {
        segmentcontols = UISegmentedControl(items: ["6 код", "9 код", "8 код"])
        self.superView.addSubview(segmentcontols)
        segmentcontols.addTarget(self, action: #selector(handleSelgmentChange), for: .valueChanged)

     
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
        
        segmentcontols.snp.makeConstraints { (make) in
            make.top.equalTo(superView).offset(100)
            make.width.equalTo(300)
            make.height.equalTo(100)
            make.leading.equalTo(50)
        }
    }
    
    @objc func handleSelgmentChange() {
      
        hiddenTF.text = ""
        Singleton.shared.pinCode = "000000000"
        
        switch segmentcontols.selectedSegmentIndex {
        case 0: Singleton.shared.formatCode = CodeFormat.sixNumbers
        case 1: Singleton.shared.formatCode = CodeFormat.nineNumbers
        case 2: Singleton.shared.formatCode = CodeFormat.eightNumbers
        default:
            Singleton.shared.formatCode = CodeFormat.nineNumbers
        }
        viewModel?.codeFormatSelector()
        pinCodeLabel.text = viewModel?.maskPinCode(code: Singleton.shared.pinCode)
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
    
    @objc func  textFieldDidChange(sender: UITextField) {
        hiddenTF.checkMaxLength(maxLength: Singleton.shared.formatCode.rawValue)
        let text = viewModel?.addingZeroToText()
        pinCodeLabel.text = viewModel!.maskPinCode(code: text!)
    }
    
}

extension ViewController: MainViewModelDelegate{
    
    func switchText() -> String {
        let countText = hiddenTF.text?.count
        
        
        if Singleton.shared.formatCode == CodeFormat.nineNumbers{
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
        } else if Singleton.shared.formatCode == CodeFormat.sixNumbers {
            switch countText {
            case 0: pinCode = "000000"
            case 1: pinCode = hiddenTF.text! + "000000"
            case 2: pinCode = hiddenTF.text! + "0000"
            case 3: pinCode = hiddenTF.text! + "000"
            case 4: pinCode = hiddenTF.text! + "00"
            case 5: pinCode = hiddenTF.text! + "0"
            default: pinCode   = hiddenTF.text!
            }
        } else if Singleton.shared.formatCode == CodeFormat.eightNumbers {
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
        return Singleton.shared.pinCode
    }
    
    func changeColorText(text: String) {
        let range = (text as NSString).range(of: hiddenTF.text!)
        let attributedString = NSMutableAttributedString(string:hiddenTF.text!)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        pinCodeLabel.attributedText = attributedString
    }
    
}
