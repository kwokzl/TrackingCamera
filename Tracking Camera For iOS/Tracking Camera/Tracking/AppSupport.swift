//
//  ActionSupport.swift
//  Tracking Camera
//
//  Created by Zonlin Kwok on 2025/7/25.
//

import Foundation
import Vision
import SwiftUI

class AppSupport:ObservableObject{
    
    static let cameraSupport=CameraSupport()
    static let actionSupport=ActionSupport()
    static var state:HardwareState = .stop
}

class ActionSupport:ObservableObject{
    @Published var hardwareState:HardwareState = .stop
    func handle(ob:VNFaceObservation){
        
    }
}


enum HardwareState:String{
    case front="向前"
    case back="向后"
    case left="向左"
    case right="向右"
    case stop="OK"
}

func MV(ob:VNFaceObservation){
    let maxFace=ob
    let pixelHeight = (maxFace.boundingBox.height) * CGFloat(UIScreen.main.nativeBounds.height)
    
    let focalLength_px: CGFloat = 1500
    
    let realFaceHeight: CGFloat = 0.15
    
    let distance = (realFaceHeight * focalLength_px) / pixelHeight
    
    print("position: x=\(maxFace.boundingBox.origin.x), y=\(maxFace.boundingBox.origin.y)")
    
    let x=maxFace.boundingBox.origin.x
    
    let y=maxFace.boundingBox.origin.y
    
    if(distance<0.4){
//        rAndL(y:y)
        print("a:向后")
        AppSupport.state = .back
    }else if distance>0.6{
//        rAndL(y:y)
        print("a:向前")
        AppSupport.state = .front
    }else{
//        rAndL(y:y)
//        print("a: ok")
//        AppSupport.state = .stop
        rAndL(y:y)
    }
    
    
    
}

func rAndL(y:Double){
    if(y<0.3){
        print("a:向左")
        AppSupport.state = .left
    }else if y>0.5{
        print("a:向右")
        AppSupport.state = .right
    }else{
        print("a: ok")
        AppSupport.state = .stop
    }
}
