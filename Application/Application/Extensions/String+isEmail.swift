//
//  String+isEmail.swift
//  Application
//

import UIKit

extension String {
    
    public var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: self.count))
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
}
