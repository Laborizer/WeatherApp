//
//  CityForecastViewController.swift
//  WeatherApp
//
//  Created by Lauri Laiho on 09/10/2019.
//  Copyright © 2019 Lauri Laiho. All rights reserved.
//

import UIKit
import CoreLocation

class CityForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    var gradientLayer: CAGradientLayer?
    var weatherDataController: WeatherDataController?
    var cities = [City]()
    let cellReuseIdentifier = "cell"
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addGradientToView(view: self.view)
        self.citiesTableView.backgroundColor = UIColor.clear
        self.citiesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.citiesTableView.delegate = self
        self.citiesTableView.dataSource = self
        
        self.citiesTableView.reloadData()
        self.citiesTableView.tableFooterView = UIView()
        self.addCities()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.citiesTableView.reloadData()
    }
    
    func addCities() {
        let useGps = City(name: "Use GPS", latitude: 37.77339720, longitude: -122.43129700)
        let tampere = City(name: "Tampere", latitude: 61.49911, longitude: 23.78712)
        let helsinki = City(name: "Helsinki", latitude: 60.16952, longitude: 24.93545)
        let turku = City(name: "Turku", latitude: 60.45148, longitude: 22.26869)
        
        let citylist = [useGps, tampere, helsinki, turku]
        for city in citylist {
            self.cities.append(city)
            self.citiesTableView.reloadData()
        }
        
        DispatchQueue.main.async(execute: {() in
            do {
                self.citiesTableView.reloadData()
            } catch {
                print(error)
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        let currentLastItem = cities[indexPath.row]
        
        cell!.layer.backgroundColor = UIColor.clear.cgColor
        cell!.textLabel?.text = cities[indexPath.row].name
        cell!.textLabel?.textColor = UIColor.white
        cell!.layer.backgroundColor = UIColor.clear.cgColor
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.cities[indexPath.row].name == "Use GPS") {
            addNewCity()
            self.citiesTableView.reloadData()
        } else {
            self.weatherDataController!.latitude = self.cities[indexPath.row].latitude
            self.weatherDataController!.longitude = self.cities[indexPath.row].longitude
            
            let currentUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(self.weatherDataController!.latitude!)&lon=\(self.weatherDataController!.longitude!)&units=metric&APPID=327b73ea7d94c0c1871610cb070cda9d"
            let forecastUrl = "https://api.openweathermap.org/data/2.5/forecast?lat=\(self.weatherDataController!.latitude!)&lon=\(self.weatherDataController!.longitude!)&units=metric&APPID=327b73ea7d94c0c1871610cb070cda9d"
            
            self.weatherDataController!.fetchCurrentWeather(url: currentUrl, view: nil)
            self.weatherDataController!.fetchForecastWeather(url: forecastUrl, view: nil)
        }
        self.citiesTableView.reloadData()
    }
    
    func isCityUnique(cityName: String) -> Bool {
        var result = true
        for city in self.cities {
            if (city.name == cityName) {
                result = false
            }
        }
        
        return result
    }
    
    func addNewCity() {
        let clGeoCoder = CLGeocoder()
        clGeoCoder.reverseGeocodeLocation(self.currentLocation!, completionHandler: { (placemarks, error) in
            if (error != nil) {
                print("Reverse geocoder failed with an error")
            } else if (placemarks!.count > 0 && self.isCityUnique(cityName: placemarks![0].locality!)) {
                let newCity = City(name: placemarks![0].locality!, latitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude)
                self.cities.append(newCity)
                self.citiesTableView.reloadData()
                
                DispatchQueue.main.async(execute: {() in
                    do {
                        self.citiesTableView.reloadData()
                    } catch {
                        print(error)
                    }
                })
            } else if (!self.isCityUnique(cityName: placemarks![0].locality!)) {
                print("City name was not unique")
            } else {
                print("Problems with the data received from geocoder.")
            }
        })
    }
    
    func addGradientToView(view: UIView) {
        self.gradientLayer = CAGradientLayer()
        gradientLayer!.colors = [UIColor.black.cgColor,    UIColor.gray.cgColor, UIColor.black.cgColor]
        gradientLayer!.locations = [0.0, 0.5, 1.0]
        view.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        self.gradientLayer!.frame = self.view.bounds
    }
    
    
}
