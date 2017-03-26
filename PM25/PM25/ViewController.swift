//
//  ViewController.swift
//  PM25
//
//  Created by 我是五高你敢信 on 2017/3/26.
//  Copyright © 2017年 我是五高你敢信. All rights reserved.
//

import UIKit
import Alamofire

let PMAppKey = "5j1znBVAsnSf5xQyNQyq"
let PMUrl = "http://www.pm25.in/api/querys/pm2_5.json"

let MapKey = "PRxNmheq44jDLC5xlNMryqGqDSxoGx9b"


class ViewController: UIViewController {
    
    let localService = BMKLocationService()
    let reverseGeoCodeOption = BMKReverseGeoCodeOption()
    var city: String = ""
    
    var model: Model!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localService.startUserLocationService()

    }
    
    //MARK: - 请求数据
    fileprivate func updateData() {
        
        city = city.substring(to: city.index(before: city.endIndex))
        let parameters = ["city": city, "token": PMAppKey]
        
        Alamofire.request(PMUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { json in
            
            if json.result.description == "SUCCESS" {
                
                let array = json.result.value as! [[String: String]]
                
                let dict = array[0]
                
                guard let area = dict["area"] else {
                    return
                }
                
                guard let pm25 = dict["pm2_5_24h"] else {
                    return
                }
                
                guard let quality = dict["quality"] else {
                    return
                }
                
                self.model = Model(area: area, pm25: pm25, quality: quality)
            }
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localService.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        localService.delegate = nil
    }
    
    
}

extension ViewController: BMKLocationServiceDelegate {
    
    //MARK: - 更新定位获得定位信息
    func didUpdate(_ userLocation: BMKUserLocation!) {
        
        
        localService.stopUserLocationService()
        
        getReverseGeoCode(location: userLocation)
        
    }
    
    func getReverseGeoCode(location: BMKUserLocation) {
        
        // 获取精度纬度
        let longitude = location.location.coordinate.longitude
        let latitude = location.location.coordinate.latitude
        
        // 根据精度纬度转换成坐标
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        // 根据坐标反编码获得城市地址
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(location, completionHandler: {[weak self] placemarks,error in
            
            guard let placemarks = placemarks else {
                return
            }
            
            for placeMark in placemarks {
                let addressDict = placeMark.addressDictionary as! [String: Any]
                
                self?.city = addressDict["City"] as! String
                
                self?.updateData()
            }
            
        })
    }
    
   
}


struct Model {
    
    var area: String
    var pm2_5_24h: String
    var quality: String
    
    init(area: String, pm25: String, quality: String) {
        
        self.area = area
        self.pm2_5_24h = pm25
        self.quality = quality
    }
}





