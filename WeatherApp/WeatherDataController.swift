//
//  WeatherDataController.swift
//  WeatherApp
//
//  Created by Lauri Laiho on 09/10/2019.
//  Copyright © 2019 Lauri Laiho. All rights reserved.
//

import Foundation
import UIKit

class WeatherDataController {
    
    var currentDataModel: WeatherDataModel?
    var forecastDataModel: ForecastDataModel?
    var latitude: Double?
    var longitude: Double?
    var currentWeatherView: CurrentWeatherViewController?
    var forecastWeatherView: ForecastViewController?
    var currentImage: UIImage?
    
    func fetchCurrentWeather(url : String, view: CurrentWeatherViewController?) {
        if (view != nil) {
            self.currentWeatherView = view
        }
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: doneFetchingCurrentWeather);
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    func doneFetchingCurrentWeather(data: Data?, response: URLResponse?, error: Error?) {
        // Execute stuff in UI thread
        DispatchQueue.main.async(execute: {() in
            do {
                let testModel = try! JSONDecoder().decode(WeatherDataModel.self, from: data!)
                self.currentDataModel = testModel
                self.updateCurrentWeatherUI()
                
            } catch {
                print(error)
            }
        })
    }
    
    func updateCurrentWeatherUI() {
        currentWeatherView?.cityNameLabel.text! = self.currentDataModel!.name + ", " + self.currentDataModel!.sys.country
        currentWeatherView?.weatherInfoLabel.text! = self.currentDataModel!.weather[0].main
        currentWeatherView?.temperatureLabel.text! = String(self.currentDataModel!.main.temp) + "°C"
        let iconCode = self.currentDataModel?.weather[0].icon
        let url = URL(string: "https://openweathermap.org/img/w/\(iconCode!).png")!
        downloadImage(from: url)
    }
    
    func fetchForecastWeather(url : String, view: ForecastViewController?) {
        if (view != nil) {
            self.forecastWeatherView = view
        }
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: doneFetchingForecastWeather);
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    func doneFetchingForecastWeather(data: Data?, response: URLResponse?, error: Error?) {
        // Execute stuff in UI thread
        DispatchQueue.main.async(execute: {() in
            do {
                let forecastModel = try! JSONDecoder().decode(ForecastDataModel.self, from: data!)
                self.forecastDataModel = forecastModel
                
                self.forecastWeatherView?.createIconsArray()
                self.forecastWeatherView?.createForecastsArray()
                
            } catch {
                print(error)
            }
        })
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.currentWeatherView?.weatherIconImageView.image = UIImage(data: data)
            }
        }
    }
    
    func downloadIcons(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                let icon = UIImage(data: data)
                self.forecastWeatherView?.icons.append(icon!)
            }
        }
    }
}
