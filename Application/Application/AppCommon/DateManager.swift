//
//  DateManager.swift
//  Application
//

import UIKit

final class DateManager {
    
    // MARK: - Constants.
    
    static let spaceFormat = 0
    static let dotFormat = 1
    
    // MARK: - getDateFromString function.
    
    public static func getDateFromString(string: String?) -> Date {
        if #available(iOS 15.0, *) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let str = string![string!.startIndex..<string!.index(string!.startIndex, offsetBy: 19)]
            let date = dateFormatter.date(from: String(str))!
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
            let finalDate = calendar.date(from:components)
            return finalDate!
        }
        return Date()
    }
    
    // MARK: - getStringDate function.
    
    public static func getStringDate(string: String?, type: Int = 0) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        let finalDate = getDateFromString(string: string)
        switch type {
        case DateManager.spaceFormat:
            dateFormatter.dateFormat = "dd MMMM yyyy"
        default:
            dateFormatter.dateFormat = "dd.MM.yyyy"
        }
        return dateFormatter.string(from: finalDate)
    }
}

