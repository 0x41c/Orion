//
//  NSColor+fromWebRGB.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-04.
//

import Foundation
import Cocoa

extension NSColor {

    /// Returns whether the color is a generally dark color
    var isDark: Bool {
        return self.getBrightness() < 0.7
    }

    /// Returns whether the color is a generally light color
    var isLight: Bool {
        return self.getBrightness() > 0.7
    }

    /// Takes a CSS `rgb` or `rgba` value, parses it, and if valid, returns
    /// a new color from it. If not valid returns nil
    ///
    ///  - Parameters:
    ///     - webRGB: The `rgb` or `rgba` value representing a color
    convenience init?(webRGB colorString: String) {
        if colorString.hasPrefix("rgb") {
            var colorStringCopy: String = colorString
            if colorString.hasPrefix("rgba") {
                colorStringCopy.removeFirst(4)
            } else {
                colorStringCopy.removeFirst(3)
            }
            colorStringCopy.removeAll { char in
                char == ","
            }
            colorStringCopy.removeFirst()
            colorStringCopy.removeLast()
            var values: [CGFloat] = colorStringCopy.split(separator: " ").map { sub in
                var ret = CGFloat(Int(sub)!)
                if ret != 0 {
                    ret /= 255
                }
                return ret
            }
            if values.count == 3 {
                values.append(1.0)
            }
            self.init(
                red: values[0],
                green: values[1],
                blue: values[2],
                alpha: values[3]
            )
        } else {
            return nil
        }
    }

    private func getBrightness() -> Float {
        if let colorComponents: [CGFloat] = self.cgColor.components {
            return Float((
                (colorComponents[0] * 299) + (colorComponents[1] * 597) + (colorComponents[2] * 114)
            ) / 1000)
        }
        return 0.0
    }

    // Thanks for this @workingdog
    // https://stackoverflow.com/a/68680901

    /// Creates self with
    convenience init(hex: String) {
        let trimHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let dropHash = String(trimHex.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines)
        let hexString = trimHex.starts(with: "#") ? dropHash : trimHex
        let ui64 = UInt64(hexString, radix: 16)
        let value = ui64 != nil ? Int(ui64!) : 0
        // #RRGGBB
        var components = (
            R: CGFloat((value >> 16) & 0xff) / 255,
            G: CGFloat((value >> 08) & 0xff) / 255,
            B: CGFloat((value >> 00) & 0xff) / 255,
            a: CGFloat(1)
        )
        if String(hexString).count == 8 {
            // #RRGGBBAA
            components = (
                R: CGFloat((value >> 24) & 0xff) / 255,
                G: CGFloat((value >> 16) & 0xff) / 255,
                B: CGFloat((value >> 08) & 0xff) / 255,
                a: CGFloat((value >> 00) & 0xff) / 255
            )
        }
        self.init(red: components.R, green: components.G, blue: components.B, alpha: components.a)
    }

    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        var alpha = Float(1.0)

        if components.count >= 4 {
            alpha = Float(components[3])
        }

        if alpha != 0.0 {
            return String(
                format: "%02lX%02lX%02lX%02lX",
                lroundf(red * 255),
                lroundf(green * 255),
                lroundf(blue * 255),
                lroundf(alpha * 255)
            )
        } else {
            return String(
                format: "%02lX%02lX%02lX",
                lroundf(red * 255),
                lroundf(green * 255),
                lroundf(blue * 255)
            )
        }
    }

}
