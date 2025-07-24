//
//  DFace.swift
//  Tracking Camera
//
//  Created by Zonlin Kwok on 2025/7/24.
//

import Foundation
import Vision
import AVFoundation


extension CameraSupport{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let request = VNDetectFaceRectanglesRequest { request, error in
            if error != nil {
                print("error")
                return
            }
            
            guard let observations = request.results as? [VNFaceObservation] else { return }
            self.observations=observations
            
            
        }
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer)
        do {
            try handler.perform([request])
        } catch {
            print("处理请求失败: \(error)")
        }
    }
}
