//
//  Int+Ext.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 03/06/24.
//

import Foundation
extension Int {
    func toHoursMinutes() -> String {
        guard self > 0 else{return "0m"}
        let hours = self / 60
        let minutes = self % 60
        return "\(hours)h \(minutes)m"
    }
}
