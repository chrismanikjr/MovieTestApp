//
//  Int+Ext.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 03/06/24.
//

import Foundation
extension Int {
    func toHoursMinutes() -> String {
        let hours = self / 60
        let minutes = self % 60
        return "\(hours)h \(minutes)m"
    }
}
