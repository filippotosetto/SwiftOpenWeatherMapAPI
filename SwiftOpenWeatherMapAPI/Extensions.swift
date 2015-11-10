//
//  Extensions.swift
//  SwiftOpenWeatherMapAPI
//
//  Created by Filippo Tosetto on 10/11/2015.
//
//

import Foundation

extension Double {
    func convertTimeToString() -> String{
        let currentDateTime = NSDate(timeIntervalSince1970: self)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM hh:mm"
        return dateFormatter.stringFromDate(currentDateTime)
    }
}