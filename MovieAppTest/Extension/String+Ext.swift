//
//  String+Ext.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 03/06/24.
//

import Foundation

extension String {
    func extractYear() -> String? {
        let dateFormatter = DateFormatter()
        if self.contains("T") {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
        
        if let date = dateFormatter.date(from: self) {
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            return yearFormatter.string(from: date)
        }
        
        return nil
    }
    
    func toDateString() -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: self){
            let displayDateFormatter = DateFormatter()
            displayDateFormatter.dateFormat = "d MMMM yyyy"
            displayDateFormatter.locale = Locale(identifier: "en_US_POSIX")
            return displayDateFormatter.string(from: date)
        }
        return nil
    }
}

