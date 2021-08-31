//
//  ModelView.swift
//  workArounPickPack
//
//  Created by Daryna Polevyk on 29.08.2021.
//

import Foundation

//протокол для связи ViewController и ViewControllerViewModel (Делигат)
protocol HomeViewViewModelType: class {
    func codeFormatSelector()
    func addingZeroToText() -> String
    func maskPinCode(code: String) -> String
    func colorChangeForText(text: String)
    func formatCodeValue() -> CodeFormat
    var delegate: MainViewModelDelegate? { get set }
}

protocol MainViewModelDelegate: AnyObject {

    func switchText() -> String
   // func formattedPinCode(code: String) -> String
    func changeColorText(text: String)
}

class ViewControllerModelView: HomeViewViewModelType {
   
    weak var delegate: MainViewModelDelegate?
    
    func codeFormatSelector() {
        switch Singleton.shared.formatCode {
        case .sixNumbers: Singleton.shared.mask = "### ###"
        case .nineNumbers: Singleton.shared.mask = "### ### ###"
        case .eightNumbers: Singleton.shared.mask = "#### ####"
        }
    }
    
    func addingZeroToText() -> String {
        return  (delegate?.switchText())!
    }
    func maskPinCode(code: String) -> String {
        
        let cleanPinCode = code.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = cleanPinCode.startIndex
        for ch in Singleton.shared.mask where index < cleanPinCode.endIndex {
            if ch == "#" {
                result.append(cleanPinCode[index])
                index = cleanPinCode.index(after: index)
            } else {
                result.append(ch)
            }
        }
       
        return result
        //(delegate?.formattedPinCode(code: code))!
    }
    func colorChangeForText(text: String) {
        
        delegate?.changeColorText(text: text)
    }
    
    func formatCodeValue() -> CodeFormat {
        
        
        return Singleton.shared.formatCode
    }
    
    
}
