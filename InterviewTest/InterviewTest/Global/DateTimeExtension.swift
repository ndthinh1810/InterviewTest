//
//  DateTimeExtension.swift
//  InterviewTest
//
//  Created by Nguyễn Đức Thịnh on 10/15/20.
//  Copyright © 2020 Duc Thinh. All rights reserved.
//

import Foundation
func buildFormatter(locale: Locale, hasRelativeDate: Bool = false, dateFormat: String? = nil) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = .medium
    if let dateFormat = dateFormat { formatter.dateFormat = dateFormat }
    formatter.doesRelativeDateFormatting = hasRelativeDate
    formatter.locale = locale
    return formatter
}

func dateFormatterToString( formatter: DateFormatter,  date: Date) -> String {
       return formatter.string(from: date)
}
