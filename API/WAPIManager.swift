//
//  WAPIManager.swift
//  YetAnotherWeatherApp
//
//  Created by Filippo Tosetto on 11/04/2015.
//

import Foundation
import MapKit
import Alamofire
import SwiftyJSON


public enum TemperatureFormat: String {
    case Celsius = "metric"
    case Fahrenheit = "imperial"
    case Kelvin = ""
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

public enum WeatherResult {
    case Success(JSON)
    case Error(String)

    public var isSuccess: Bool {
        switch self {
        case .Success:
            return true
        case .Error:
            return false
        }
    }
}


public class WAPIManager {

    private var params = [String : String]()
    public var temperatureFormat: TemperatureFormat = .Kelvin {
        didSet {
            params["units"] = temperatureFormat.rawValue
        }
    }

    public var language: Language = .English {
        didSet {
            params["lang"] = language.rawValue
        }
    }

    public init(apiKey: String) {
        params["APPID"] = apiKey
    }

    public convenience init(apiKey: String, temperatureFormat: TemperatureFormat) {
        self.init(apiKey: apiKey)
        self.temperatureFormat = temperatureFormat
        self.params["units"] = temperatureFormat.rawValue

    }

    public convenience init(apiKey: String, temperatureFormat: TemperatureFormat, lang: Language) {
        self.init(apiKey: apiKey, temperatureFormat: temperatureFormat)

        self.language = lang
        self.temperatureFormat = temperatureFormat

        params["units"] = temperatureFormat.rawValue
        params["lang"] = lang.rawValue
    }
}

// MARK: Private functions
extension WAPIManager {
    private func apiCall(method: Router, response: @escaping (WeatherResult) -> Void) {
        Alamofire.request(method).responseJSON { (data) in
            guard let js: AnyObject = data.value as AnyObject? else {
                response(WeatherResult.Error(data.error.debugDescription))
                return
            }
            response(WeatherResult.Success(JSON(js)))
        }
    }
}

enum Router: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        fatalError()
    }

    static let baseURLString = "http://api.openweathermap.org/data/"
    static let apiVersion = "2.5"

    case Weather([String: AnyObject])
    case ForeCast([String: AnyObject])
    case DailyForecast([String: AnyObject])
    case HirstoricData([String: AnyObject])

    var method: HTTPMethod {
        return HTTPMethod.get
    }

    var path: String {
        switch self {
        case .Weather:
            return "/weather"
        case .ForeCast:
            return "/forecast"
        case .DailyForecast:
            return "/forecast/daily"
        case .HirstoricData:
            return "/history/city"
        }
    }

    // MARK: URLRequestConvertible
    var URLRequest: DataRequest? {
        guard let URL = NSURL(string: Router.baseURLString + Router.apiVersion) else { return nil }
        guard let pathURL = URL.appendingPathComponent(path) else { return nil }

        func encode(params: [String: AnyObject]) -> DataRequest {
            return Alamofire.request(pathURL.absoluteString,
                                     method: method,
                                     parameters: params)
                .responseJSON { (response: DataResponse<Any>) in
                    guard let json = response.result.value as? [String:Any] else { return }
                    print("\(json)")
            }
        }

        switch self {
        case .Weather(let parameters):
            return encode(params: parameters)
        case .ForeCast(let parameters):
            return encode(params: parameters)
        case .DailyForecast(let parameters):
            return encode(params: parameters)
        case .HirstoricData(let parameters):
            return encode(params: parameters)
        }
    }
}


//MARK: - Get Current Weather
extension WAPIManager {

    private func currentWeather(params: [String:AnyObject], data: @escaping (WeatherResult) -> Void) {
        apiCall(method: Router.Weather(params)) { data($0) }
    }

    public func currentWeatherByCityNameAsJson(cityName: String, data: @escaping (WeatherResult) -> Void) {
        params["q"] = cityName

        currentWeather(params: params as [String : AnyObject]) { data($0) }
    }

    public func currentWeatherByCoordinatesAsJson(coordinates: CLLocationCoordinate2D, data: @escaping (WeatherResult) -> Void) {

        params["lat"] = String(stringInterpolationSegment: coordinates.latitude)
        params["lon"] = String(stringInterpolationSegment: coordinates.longitude)

        currentWeather(params: params as [String : AnyObject]) { data($0) }
    }

}

//MARK: - Get Forecast
extension WAPIManager {

    private func forecastWeather(parameters: [String:AnyObject], data: @escaping (WeatherResult) -> Void) {
        apiCall(method: Router.ForeCast(params as [String : AnyObject])) { data($0) }
    }

    public func forecastWeatherByCityNameAsJson(cityName: String, data: @escaping (WeatherResult) -> Void) {
        params["q"] = cityName

        forecastWeather(parameters: params as [String : AnyObject]) { data($0) }
    }

    public func forecastWeatherByCoordinatesAsJson(coordinates: CLLocationCoordinate2D, data: @escaping (WeatherResult) -> Void) {

        params["lat"] = String(stringInterpolationSegment: coordinates.latitude)
        params["lon"] = String(stringInterpolationSegment: coordinates.longitude)

        forecastWeather(parameters: params as [String : AnyObject]) { data($0) }
    }

}

//MARK: - Get Daily Forecast
extension WAPIManager {

    private func dailyForecastWeather(parameters: [String:AnyObject], data: @escaping (WeatherResult) -> Void) {
        apiCall(method: Router.DailyForecast(params as [String : AnyObject])) { data($0) }
    }

    public func dailyForecastWeatherByCityNameAsJson(cityName: String, data: @escaping (WeatherResult) -> Void) {
        params["q"] = cityName

        dailyForecastWeather(parameters: params as [String : AnyObject]) { data($0) }
    }

    public func dailyForecastWeatherByCoordinatesAsJson(coordinates: CLLocationCoordinate2D, data: @escaping (WeatherResult) -> Void) {

        params["lat"] = String(stringInterpolationSegment: coordinates.latitude)
        params["lon"] = String(stringInterpolationSegment: coordinates.longitude)

        dailyForecastWeather(parameters: params as [String : AnyObject]) { data($0) }
    }

}


//MARK: - Get Historic Data
extension WAPIManager {

    private func historicData(parameters: [String:AnyObject], data: @escaping (WeatherResult) -> Void) {
        params["type"] = "hour"

        apiCall(method: Router.HirstoricData(params as [String : AnyObject])) { data($0) }
    }

    public func historicDataByCityNameAsJson(cityName: String, start: NSDate, end: NSDate?, data: @escaping (WeatherResult) -> Void) {
        params["q"] = cityName

        params["start"] = "\(start.timeIntervalSince1970)"
        if let endDate = end {
            params["end"] = "\(endDate.timeIntervalSince1970)"
        }

        historicData(parameters: params as [String : AnyObject]) { data($0) }
    }

    public func historicDataByCoordinatesAsJson(coordinates: CLLocationCoordinate2D, start: NSDate, end: NSDate?, data: @escaping (WeatherResult) -> Void) {

        params["lat"] = String(stringInterpolationSegment: coordinates.latitude)
        params["lon"] = String(stringInterpolationSegment: coordinates.longitude)

        params["start"] = "\(start.timeIntervalSince1970)"
        if let endDate = end {
            params["end"] = "\(endDate.timeIntervalSince1970)"
        }

        historicData(parameters: params as [String : AnyObject]) { data($0) }
    }

}

