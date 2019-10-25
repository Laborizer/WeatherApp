//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Lauri Laiho on 09/10/2019.
//  Copyright © 2019 Lauri Laiho. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    //var weatherDataController: WeatherDataController?
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    var currentWeatherViewController: CurrentWeatherViewController?
    var forecastWeatherViewController: ForecastViewController?
    var cityWeatherViewController: CityForecastViewController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestAlwaysAuthorization()
        locationManager!.startUpdatingLocation()
        
        window?.rootViewController = createTabs()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func createTabs() -> UITabBarController {
        self.currentWeatherViewController = CurrentWeatherViewController(nibName: "CurrentWeatherView", bundle: nil)
        currentWeatherViewController!.title = "Current Weather"
        
        self.forecastWeatherViewController = ForecastViewController(nibName: "ForecastView", bundle: nil)
        self.forecastWeatherViewController!.title = "5-day forecast"
        
        self.cityWeatherViewController = CityForecastViewController(nibName: "CityForecastView", bundle: nil)
        self.cityWeatherViewController!.title = "City"
        
        let tabs = UITabBarController()
        tabs.viewControllers = [currentWeatherViewController!, forecastWeatherViewController!, cityWeatherViewController!]
        tabs.tabBar.barTintColor = UIColor.black
        
        return tabs
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager!.stopUpdatingLocation()
        self.currentLocation = locationManager?.location
        let lon = self.currentLocation?.coordinate.longitude
        let lat = self.currentLocation?.coordinate.latitude
        
        let weatherDataCont = WeatherDataController()
        weatherDataCont.latitude = lat
        weatherDataCont.longitude = lon
        currentWeatherViewController?.weatherDataController = weatherDataCont
        forecastWeatherViewController?.weatherDataController = weatherDataCont
        cityWeatherViewController?.weatherDataController = weatherDataCont
        cityWeatherViewController?.currentLocation = CLLocation(latitude: lat!, longitude: lon!)
        currentWeatherViewController?.updateWeatherData()
    }
}

