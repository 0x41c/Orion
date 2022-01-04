//
//  String.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-02.
//

import Foundation

extension String {
    /// Checks if a String is a valid URL using `NSDataDetector`
    var isValidURL: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            if let match = detector.firstMatch(
                in: self,
                options: [],
                range: NSRange(
                    location: 0,
                    length: self.utf16.count
                )
                ) {
                return match.range.length == self.utf16.count
            } else {
                return false
            }
        } catch {
          fatalError("[Error] Could not create NSDataDetector (?): \(error)")
        }
    }

    /// Returns a random alphanumeric string with the specified length
    ///
    ///  - Parameters:
    ///     - length: The length of the wanted target string
    static func random(_ length: Int) -> Self {
        let alphaNumerals = "abcdefghijklmnopqrstuvwxyz1234567890"
        return String((0..<length).map { _ in alphaNumerals.randomElement()! })
    }

}
