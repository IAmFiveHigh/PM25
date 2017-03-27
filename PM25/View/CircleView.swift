//
//  CircleView.swift
//  AnimationMaster
//
//  Created by 我是五高你敢信 on 2017/2/24.
//  Copyright © 2017年 我是五高你敢信. All rights reserved.
//

import UIKit

class CircleView: UIView {

    fileprivate let lineWidth: CGFloat
    var lineColor: UIColor
    fileprivate let clockWise: Bool
    fileprivate let shapeLayer = CAShapeLayer()
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - lineWidth: 线宽
    ///   - lineColor: 颜色
    ///   - clockWise: 是否顺时针
    init(frame: CGRect, lineWidth: CGFloat = 1, lineColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), clockWise: Bool = true) {
        
        self.clockWise = clockWise
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        
        super.init(frame: frame)
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CircleView {
    
    /// 设置圆弧的起始角度和结束角度
    ///
    /// - Parameters:
    ///   - starAngle: 起始角度
    ///   - endAngle: 结束角度
    func set(starAngle: CGFloat, endAngle: CGFloat, animation: Bool) {
        
        let sAngle = starAngle / 180 * CGFloat(M_PI) - CGFloat(M_PI_2)
        let eAngle = endAngle / 180 * CGFloat(M_PI) - CGFloat(M_PI_2)
        
        makeEffective(starAngle: sAngle, endAngle: eAngle, animation: animation)
    }
    
    fileprivate func makeEffective(starAngle: CGFloat, endAngle: CGFloat, animation: Bool) {
        
        let size = bounds.size
        let radius = (size.width - lineWidth) / 2
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: size.width / 2, y: size.height / 2), radius: radius, startAngle: starAngle, endAngle: endAngle, clockwise: clockWise)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = lineColor.cgColor
        
        if animation {
            
            let anima = CABasicAnimation(keyPath: "strokeEnd")
            anima.duration = 0.5
            anima.fromValue = 0
            anima.toValue = 1.0
            anima.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            shapeLayer.add(anima, forKey: "strokeEnd")
        }
    }
}

//MARK: - 动画
extension CircleView {
    
    func strokeEnd(value: CGFloat, duration: TimeInterval) {
        
        var strokeValue = value
        if strokeValue > 1 {
            
            strokeValue = 1
        }else if strokeValue < 0 {
            
            strokeValue = 0
        }
        
        let animation = CAKeyframeAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.values = KeyFrame(frameCount: Int(duration) * 60).frameValues(fromValue: 0, toValue: strokeValue)
        shapeLayer.strokeEnd = CGFloat(strokeValue)
        shapeLayer.add(animation, forKey: "strokeEnd")
    }
}
