//
//  PageViewController.swift
//  WeatherGift
//
//  Created by Brandon Boey on 3/21/20.
//  Copyright © 2020 Brandon Boey. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var weatherLocations: [WeatherLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        loadLocations()
        setViewControllers([createLocationDetailViewController(forPage: 0)], direction: .forward, animated: false, completion: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func loadLocations() {
        guard let locationsEncoded = UserDefaults.standard.value(forKey: "weatherLocations") as? Data else {
            print("Error could not load data. this would always be the case the first time an app is installed.")
            //TODO: Get user location for the first element in weather locations
            weatherLocations.append(WeatherLocation(name: "", latitude: 20.20, longitude: 20.20))
            return
        }
        let decoder = JSONDecoder()
        if let weatherLocations = try? decoder.decode(Array.self, from: locationsEncoded) as [WeatherLocation] {
            self.weatherLocations = weatherLocations
        } else {
            print("Error could not decode data from UserDefaults")
        }
        //TODO: Get user location for the first element in weather locations
        if weatherLocations.isEmpty {
            weatherLocations.append(WeatherLocation(name: "Current Location", latitude: 20.20, longitude: 20.20))
        }
    }
    
    func createLocationDetailViewController(forPage page: Int) -> LocationDetailViewController {
        let detailViewController = storyboard!.instantiateViewController(identifier: "LocationDetailViewController") as! LocationDetailViewController
        detailViewController.locationIndex = page
        return detailViewController
    }
    
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex > 0 {
                return createLocationDetailViewController(forPage: currentViewController.locationIndex - 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex < weatherLocations.count - 1 {
                return createLocationDetailViewController(forPage: currentViewController.locationIndex + 1)
            }
        }
        return nil
    }
    
    
}
