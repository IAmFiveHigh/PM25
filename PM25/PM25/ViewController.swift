//
//  ViewController.swift
//  PM25
//
//  Created by 我是五高你敢信 on 2017/3/26.
//  Copyright © 2017年 我是五高你敢信. All rights reserved.
//

import UIKit

let PMAppKey = "5j1znBVAsnSf5xQyNQyq"
let PMUrl = "http://www.pm25.in/api/querys/pm2_5.json"

let MapKey = "PRxNmheq44jDLC5xlNMryqGqDSxoGx9b"


class ViewController: UIViewController {

    var localService: BMKLocationService!
    var reverseGeoCodeOption: BMKReverseGeoCodeOption!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateLocation()
    }
    
    fileprivate func updateLocation() {
        
        localService = BMKLocationService()
        localService.startUserLocationService()
        localService.delegate = self
        
    }
}

extension ViewController: BMKLocationServiceDelegate {
    
    func didUpdate(_ userLocation: BMKUserLocation!) {
        
        localService.stopUserLocationService()
        
        print("++++")
        print(userLocation.location.coordinate.latitude)
        
        reverseGeoCode(location: userLocation)
    }
    
    fileprivate func reverseGeoCode(location: BMKUserLocation) {
        
    }
}




