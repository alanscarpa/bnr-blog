//
//  DateHandler.swift
//  Blog Nerd Ranch
//
//  Created by Alan Scarpa on 11/7/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

class DateHandler {
    static let shared = DateHandler()
    private let formatter = DateFormatter()
    private let monthFormatter = DateFormatter()
    
    private init () {
        formatter.dateStyle = .short
        monthFormatter.dateFormat = "MMMM"
    }
    
    func shortStyle(fromDate date: Date) -> String {
        return formatter.string(from: date)
    }
    
    func monthString(fromDate date: Date) -> String {
        return monthFormatter.string(from: date)
    }
    
    func date(fromMonthString monthString: String) -> Date {
        return monthFormatter.date(from: monthString) ?? Date()
    }
}
