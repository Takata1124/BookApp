//
//  Extension.swift
//  practiceApp
//
//  Created by t032fj on 2024/02/24.
//

import Foundation

extension Notification.Name {
    static let notifyName = Notification.Name("notifyName")
}

extension String {
    func isNumber(digit: Int) -> Bool {
        let pattern = #"^(978)+\d{10}$"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let matches = regex.matches(in: self, range: NSRange(location: 0, length: digit))
        return matches.count > 0
    }
}
