//
//  KeyFrame.swift
//  AnimationMaster
//
//  Created by 我是五高你敢信 on 2017/2/25.
//  Copyright © 2017年 我是五高你敢信. All rights reserved.
//

import UIKit

class KeyFrame: NSObject {

    let frameCount: size_t
    
    init(frameCount: size_t) {
        
        self.frameCount = frameCount
    }
    
    func frameValues(fromValue: CGFloat, toValue: CGFloat) -> [CGFloat] {
        
        var values = [CGFloat]()
        let unitValue: CGFloat = (toValue - fromValue) / CGFloat(frameCount)
        for index in 0..<frameCount {
            
            let value = fromValue + unitValue * CGFloat(index)
            values.append(value)
            print("value = \(value)")
        }
        
        return values
    }
}
