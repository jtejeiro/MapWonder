//
//  ExtString.swift
//  MapWonder
//
//  Created by Jaime Tejeiro on 22/2/23.
//

import UIKit
import Foundation


extension String {
    
    var sLocalized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    func getStringtoDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = Kconstants.KDateFormatResponse
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func stringSeparatingCharactersWithString(_ separatedBy: String? = nil) -> [String] {
        let char = separatedBy ?? ","
        return self.components(separatedBy: char)
    }
    
    /// EZSE: Converts String to Double
    func toDouble() -> Double?
    {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

