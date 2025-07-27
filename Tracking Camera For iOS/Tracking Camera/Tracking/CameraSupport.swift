//
//  CameraSupport.swift
//  Tracking Camera
//
//  Created by Zonlin Kwok on 2025/7/24.
//

import AVFoundation
import Vision
import SwiftUI

class CameraSupport:NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate{
    @Published var isRecording = false
    @Published var lastVideoURL: URL?
    let session = AVCaptureSession()
    @Published var observation=VNFaceObservation()
    var movieFileOutput: AVCaptureMovieFileOutput?
    private func setupCamera() {
        session.sessionPreset = .photo
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input),
              let output = createOutput() else {
            fatalError("error")
        }
        session.addInput(input)
        session.addOutput(output)
    }
    
    private func createOutput() -> AVCaptureVideoDataOutput? {
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video"))
        return output
    }
    
    override init() {
        super.init()
        setupCamera()
        setupCaptureSession()
        Task{
            self.session.startRunning()
        }
    }
    
}


extension CameraView{
    
    
     func getRotationAngle() -> Angle {
            switch orientation {
            case .landscapeLeft:
                return .degrees(-90)
            case .landscapeRight:
                return .degrees(90)
//            case .portraitUpsideDown:
//                return .degrees(180)
            default:
                return .degrees(0)
            }
        }
        
         func getXOffset(geometry: GeometryProxy) -> CGFloat {
            switch orientation {
            case .landscapeLeft,.landscapeRight:
                return max(geometry.size.width, geometry.size.height)/2
            default:
                return min(geometry.size.width, geometry.size.height)/2
            }
        }
        
         func getYOffset(geometry: GeometryProxy) -> CGFloat {
            switch orientation {
            case .landscapeLeft, .landscapeRight:
                return min(geometry.size.width, geometry.size.height)/2
            default:
                return max(geometry.size.width, geometry.size.height)/2
            }
        }
}

