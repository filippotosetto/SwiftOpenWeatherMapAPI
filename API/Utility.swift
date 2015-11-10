//
//  Utility.swift
//  Pods
//
//  Created by Filippo Tosetto on 10/11/2015.
//
//

import Foundation
import SwiftyJSON

public enum TemperatureFormat {
    case Celsius, Fahrenheit, Kelvin
}

public enum Language : String {
    case English = "en",
    Russian = "ru",
    Italian = "it",
    Spanish = "es",
    Ukrainian = "uk",
    German = "de",
    Portuguese = "pt",
    Romanian = "ro",
    Polish = "pl",
    Finnish = "fi",
    Dutch = "nl",
    French = "fr",
    Bulgarian = "bg",
    Swedish = "sv",
    ChineseTraditional = "zh_tw",
    ChineseSimplified = "zh_cn",
    Turkish = "tr",
    Croatian = "hr",
    Catalan = "ca"
}

private func convertTemperature(kelvin: JSON, format: TemperatureFormat) -> JSON {
    switch format {
    case .Celsius:
        return JSON(kelvin.doubleValue - 273.15)
    case .Fahrenheit:
        return JSON((kelvin.doubleValue * 9/5) - 459.67)
    case .Kelvin:
        return JSON(kelvin.doubleValue)
    }
}

func convertResults(inout json: JSON, format: TemperatureFormat){
    if var temp = json["main"] as JSON? {
        temp["temp"]     = convertTemperature(temp["temp"], format: format)
        temp["temp_max"] = convertTemperature(temp["temp_max"], format: format)
        temp["temp_min"] = convertTemperature(temp["temp_min"], format: format)
        
        json["main"]     = temp
    }
    
    if var temp = json["temp"] as JSON? {
        temp["day"]   = convertTemperature(temp["day"], format: format)
        temp["eve"]   = convertTemperature(temp["eve"], format: format)
        temp["max"]   = convertTemperature(temp["max"], format: format)
        temp["min"]   = convertTemperature(temp["min"], format: format)
        temp["morn"]  = convertTemperature(temp["morn"], format: format)
        temp["night"] = convertTemperature(temp["night"], format: format)
        
        json["temp"]  = temp
    }
    
    let list = json["list"]
    for (key,var subJson):(String, JSON) in list {
        convertResults(&subJson, format: format)
        json["list"][Int(key)!] = subJson
    }
}
