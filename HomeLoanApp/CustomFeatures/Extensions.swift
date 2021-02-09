//
//  Extensions.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/15.
//

import Foundation
import SwiftUI
import UIKit

extension UIApplication {
    @objc func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}

extension UIDevice {
    /// Code Provided by HAS and Harshil Patel at `https://stackoverflow.com/questions/26028918/how-to-determine-the-current-iphone-device-model`
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            switch identifier {
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
                case "iPhone4,1":                               return "iPhone 4s"
                case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
                case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
                case "iPhone7,2":                               return "iPhone 6"
                case "iPhone7,1":                               return "iPhone 6 Plus"
                case "iPhone8,1":                               return "iPhone 6s"
                case "iPhone8,2":                               return "iPhone 6s Plus"
                case "iPhone8,4":                               return "iPhone SE"
                case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
                case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
                case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
                case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6":                return "iPhone X"
                case "iPhone11,2":                              return "iPhone XS"
                case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
                case "iPhone11,8":                              return "iPhone XR"
                case "iPhone12,1":                              return "iPhone 11"
                case "iPhone12,3":                              return "iPhone 11 Pro"
                case "iPhone12,5":                              return "iPhone 11 Pro Max"
                case "iPhone12,8":                              return "iPhone SE (2nd generation)"
                case "iPhone13,1":                              return "iPhone 12 mini"
                case "iPhone13,2":                              return "iPhone 12"
                case "iPhone13,3":                              return "iPhone 12 Pro"
                case "iPhone13,4":                              return "iPhone 12 Pro Max"
                case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
                default:                                        return identifier
            }
        }

        return mapToDevice(identifier: identifier)
    }()

}

extension UIView {
    func asImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension View {
    func textFieldAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                        title: String,
                        isPasswordAlert: Bool) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       text: text,
                       isPasswordAlert: isPasswordAlert,
                       presenting: self,
                       title: title)
    }
}

extension String {

    /// Parses the input text and returns a collection of rich text elements.
    /// Currently supports asterisks only. E.g. "Save *everything* that *inspires* your ideas".
    ///
    /// - Returns: A collection of rich text elements.
    func parseRichTextElements() -> [RichText.Element] {
        let regex = try! NSRegularExpression(pattern: "\\*{1}(.*?)\\*{1}")
        let range = NSRange(location: 0, length: count)

        /// Find all the ranges that match the regex *CONTENT*.
        let matches: [NSTextCheckingResult] = regex.matches(in: self, options: [], range: range)
        let matchingRanges = matches.compactMap { Range<Int>($0.range) }

        var elements: [RichText.Element] = []

        // Add the first range which might be the complete content if no match was found.
        // This is the range up until the lowerbound of the first match.
        let firstRange = 0..<(matchingRanges.count == 0 ? count : matchingRanges[0].lowerBound)

        self[firstRange].components(separatedBy: " ").forEach { (word) in
            guard !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
            elements.append(RichText.Element(content: String(word), isBold: false))
        }

        // Create elements for the remaining words and ranges.
        for (index, matchingRange) in matchingRanges.enumerated() {
            let isLast = matchingRange == matchingRanges.last

            // Add an element for the matching range which should be bold.
            let matchContent = self[matchingRange]
            elements.append(RichText.Element(content: matchContent, isBold: true))

            // Add an element for the text in-between the current match and the next match.
            let endLocation = isLast ? count : matchingRanges[index + 1].lowerBound
            let range = matchingRange.upperBound..<endLocation
            self[range].components(separatedBy: " ").forEach { (word) in
                guard !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                elements.append(RichText.Element(content: String(word), isBold: false))
            }
        }

        return elements
    }

    /// - Returns: A string subscript based on the given range.
    subscript(range: Range<Int>) -> String {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = index(self.startIndex, offsetBy: range.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

extension Float {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2 // maximum digits in Float after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String {
        Formatter.withSeparator.string(for: self) ?? ""
    }
}
