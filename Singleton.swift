//
//  Singleton.swift
//  workArounPickPack
//
//  Created by Daryna Polevyk on 29.08.2021.
//

import Foundation

class Singleton {
   static var shared = Singleton()
    var formatCode = CodeFormat.nineNumbers
    var pinCode: String = "000000000"
    var mask = ""

    private init() {
    }
    
}
