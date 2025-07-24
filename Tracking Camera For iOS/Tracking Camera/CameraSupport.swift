//
//  CameraSupport.swift
//  Tracking Camera
//
//  Created by Zonlin Kwok on 2025/7/24.
//

import AVFoundation
import Vision

class CameraSupport:NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate{
    let session = AVCaptureSession()
    @Published var observations=[VNFaceObservation]()
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
        self.session.startRunning()
    }
    
}


