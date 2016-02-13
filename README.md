# Swift Open Weather Map API
Swift Open Weather Map API is a wrapper around [OpenWeatherAPI](http://openweathermap.org)

[![Platform](https://img.shields.io/cocoapods/p/SwiftOpenWeatherMapAPI.svg?style=flat)](http://cocoadocs.org/docsets/SwiftOpenWeatherMapAPI) [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwiftOpenWeatherMapAPI.svg?style=flat)](https://img.shields.io/cocoapods/v/SwiftOpenWeatherMapAPI.svg?style=flat)   [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Requirements
- iOS 8.0+ / Mac OS X 10.9+
- Xcode 7

## Installation
### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `SwiftOpenWeatherMapAPI` adding it to your Podfile:

```Ruby
pod 'SwiftOpenWeatherMapAPI'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Alamofire into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "filippotosetto/SwiftOpenWeatherMapAPI"
```

Run `carthage update` to build the framework and drag the built `Alamofire.framework`, `SwiftyJSON.framework` and `SwiftOpenWeatherMapAPI.framework` into your Xcode project.

## Initialization
Include the header:

```Swift
import SwiftOpenWeatherMapAPI
```

Setup the api:

```Swift
// Setup weather api
let weatherAPI = WAPIManager(apiKey: "YOUR_API_KEY")

// Setup weather api with temperature format
let weatherAPI = WAPIManager(apiKey: "YOUR_API_KEY", temperatureFormat: .Celsius)

// Setup weather api with temperature format and language
let weatherAPI = WAPIManager(apiKey: "YOUR_API_KEY", temperatureFormat: .Celsius, lang: .English)
```

## Getting data
The api is at this time just simple wrapper for the http-api.

```Swift
weatherAPI.currentWeatherByCityNameAsJson("London") { (json) -> Void in
    //Do something with the data
}
```

The result is a `JSON` struct coming from mapping the api data using [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

## Usage
The following methods are available at this time:

### Current Weather
Current weather by city name:

```Swift
public func currentWeatherByCityNameAsJson(cityName: String, data: (JSON) -> Void)
```

Current weather by coordinate:

```Swift
public func currentWeatherByCoordinatesAsJson(coordinates: CLLocationCoordinate2D, data: (JSON) -> Void)
```

### Forecasts (3 hour intervals)
forecast by city name:

```Swift
public func forecastWeatherByCityNameAsJson(cityName: String, data: (JSON) -> Void)
```

forecast by coordinate:

```Swift
public func forecastWeatherByCoordinatesAsJson(coordinates: CLLocationCoordinate2D, data: (JSON) -> Void)
```

### Daily Forecasts
daily forecast by city name:

```Swift
public func dailyForecastWeatherByCityNameAsJson(cityName: String, data: (JSON) -> Void)
```

daily forecast by coordinates:

```Swift
public func dailyForecastWeatherByCoordinatesAsJson(coordinates: CLLocationCoordinate2D, data: (JSON) -> Void)
```

### Historic Data
historic data by city name:

```Swift
public func historicDataByCityNameAsJson(cityName: String, start: NSDate, end: NSDate?, data: (JSON) -> Void)
```

historic data by coordinates:

```Swift
public func historicDataByCoordinatesAsJson(coordinates: CLLocationCoordinate2D, start: NSDate, end: NSDate?, data: (JSON) -> Void)
```
