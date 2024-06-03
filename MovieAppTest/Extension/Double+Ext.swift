//
//  Double+Ext.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 03/06/24.
//

import Foundation
extension Double{
    func ratingFormat() -> String{
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f/10", self)
        } else {
            return String(format: "%.1f/10", self)
        }
    }
}
