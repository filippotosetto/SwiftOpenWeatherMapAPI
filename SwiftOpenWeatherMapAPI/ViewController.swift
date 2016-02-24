//
//  ViewController.swift
//  SwiftOpenWeatherMapAPI
//
//  Created by Filippo Tosetto on 16/04/2015.
//
//

import UIKit
import SwiftyJSON



class ViewController: UIViewController {
    
    // TODO: Set correct API key
    let apiManager = WAPIManager(apiKey: "271537219331766fbdaf30a4ef37fb33", temperatureFormat: .Celsius, lang: .Italian)
    let city = "London,UK"
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentWeather: Weather? {
        didSet {
            self.currentTemperatureLabel.text = (currentWeather?.temperature)! + " C"
            self.weatherDescriptionLabel.text = currentWeather?.description
        }
    }
    
    var weatherList = [Weather]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager.currentWeatherByCityNameAsJson(city, data: { (json) -> Void in
            self.cityNameLabel.text = json["name"].stringValue
            
            self.currentWeather = Weather(json: json)
        })
        
        apiManager.forecastWeatherByCityNameAsJson(city, data: { (json) -> Void in
            self.weatherList = json["list"].array!.map() { Weather(json: $0) }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let weather = weatherList[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) 
        cell.textLabel?.text = weather.description + " " + weather.temperature + " C"
        cell.detailTextLabel?.text = weather.dateTime
        
        return cell
    }
    
}
