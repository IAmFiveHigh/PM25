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

let BackgroundColor: (CGFloat, CGFloat, CGFloat) = (52, 117, 183)

class ViewController: UIViewController {
    
    //MARK: - 属性
    fileprivate let localService = BMKLocationService()
    fileprivate let reverseGeoCodeOption = BMKReverseGeoCodeOption()
    fileprivate var city: String = ""
    
    fileprivate var model: Model!
    
    //MARK: - UI
    fileprivate let maskView = UIView()
    fileprivate let areaLabel = UILabel()
    fileprivate let pm25Index = UILabel()
    fileprivate let qualityLabel = UILabel()
    fileprivate var cycleView: CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        localService.startUserLocationService()
        
        setupUI()

    }
    
    //MARK: - 设置界面
    fileprivate func setupUI() {
        
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor(red: BackgroundColor.0 / 255.0, green: BackgroundColor.1 / 255.0, blue: BackgroundColor.2 / 255.0, alpha: 1)
        view.addSubview(backgroundView)
        
        maskView.frame = view.bounds
        maskView.tag = 2
        maskView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        maskView.alpha = 0
        view.addSubview(maskView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        titleLabel.setCenterX(view.centerX())
        titleLabel.setCenterY(100)
        titleLabel.text = "实时PM2.5"
        titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(titleLabel)
        
        let backCycle = CircleView(frame: CGRect(x: 0, y: 0, width: 160, height: 160), lineWidth: 10, lineColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), clockWise: true)
        backCycle.center = view.center
        backCycle.set(starAngle: 225, endAngle: 495, animation: false)
        view.addSubview(backCycle)
        
        cycleView = CircleView(frame: CGRect(x: 0, y: 0, width: 160, height: 160), lineWidth: 10, lineColor: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), clockWise: true)
        cycleView.center = view.center
        view.addSubview(cycleView)
        
        areaLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
        areaLabel.setCenterX(view.centerX())
        areaLabel.setCenterY(view.centerY() - 140)
        areaLabel.text = ""
        areaLabel.textAlignment = .center
        areaLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        areaLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(areaLabel)
        
        pm25Index.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
        pm25Index.center = view.center
        pm25Index.text = ""
        pm25Index.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pm25Index.textAlignment = .center
        pm25Index.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(pm25Index)
        
        qualityLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        qualityLabel.setCenterX(view.centerX())
        qualityLabel.setCenterY(view.centerY() + 80)
        qualityLabel.layer.cornerRadius = 10
        qualityLabel.layer.masksToBounds = true
        qualityLabel.text = ""
        qualityLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        qualityLabel.textAlignment = .center
        qualityLabel.font = UIFont.systemFont(ofSize: 18)
        qualityLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(qualityLabel)
        
        updateUI()
    }
    
    
    //MARK: - 更新UI
    fileprivate func updateUI() {
        
        model = Model(area: "上海", pm25: 20, quality: "优")
        
        areaLabel.text = model.area
        
        pm25Index.text = "\(model.pm2_5_24h)"
        
        qualityLabel.text = model.quality
        
        qualityLabel.backgroundColor = model.color
        
        cycleView.lineColor = model.color
        
        let percent: Double = Double(model.pm2_5_24h) / 500
        let percentIndex = percent * (495 - 225)
        cycleView.set(starAngle: 225, endAngle: CGFloat(percentIndex) + 225, animation: true)
        
        maskView.alpha = CGFloat(model.pm25Quality.quality.rawValue) / 5
        
    }
    
    
    //MARK: - 请求数据
    fileprivate func updateData() {
        
        city = city.substring(to: city.index(before: city.endIndex))
        let parameters = ["city": city, "token": PMAppKey]
        
        Alamofire.request(PMUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { json in
            
            if json.result.description == "SUCCESS" {
                
                print("success ")
                
                if json.result.value is [[String: Any]] {
                    
                    let array = json.result.value as! [[String: Any]]
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
                    
                    self.model = Model(area: area as! String, pm25: pm25 as! Int, quality: quality as! String)
                    
//                    self.updateUI()
                }else {
                    
                    print(json.result.value ?? "sorry")
                }
                
                
                
                
            }else {
                
                print(json.result)
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
    
    let area: String
    let pm2_5_24h: Int
    let quality: String
    let pm25Quality: PM25Quality
    var color: UIColor {
        switch pm25Quality.quality {
        case .优:
            return #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        case .良:
            return #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case .轻度:
            return #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        case .中度:
            return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case .重度:
            return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        case .严重:
            return #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        }
    }
    
    init(area: String, pm25: Int, quality: String) {
        
        self.area = area
        self.pm2_5_24h = pm25
        self.quality = quality
        
        
        self.pm25Quality = PM25Quality(index: pm25)
    }
    
    fileprivate func setColor() {
        
        
    }
}

struct PM25Quality {
    
    let index: Int
    let quality: qualityLevel
    
    init(index :Int) {
        self.index = index
        
        if index > 0 && index <= 50{
            quality = .优
        }else if index > 50 && index <= 100 {
            quality = .良
        }else if index > 100 && index <= 150 {
            quality = .轻度
        }else if index > 150 && index <= 200 {
            quality = .中度
        }else if index > 200 && index <= 300 {
            quality = .重度
        }else {
            quality = .严重
        }
    }
    
    enum qualityLevel: Int {
        case 优 = 1
        case 良
        case 轻度
        case 中度
        case 重度
        case 严重
    }
}






