//
//  Extensions.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 07/03/24.
//

import Foundation

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
