//
//  DFace.swift
//  Tracking Camera
//
//  Created by Zonlin Kwok on 2025/7/24.
//

import Foundation
import Vision
import AVFoundation
import Photos


extension CameraSupport{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let request = VNDetectFaceRectanglesRequest { request, error in
            if error != nil {
                print("error")
                return
            }
            
            guard let observations = request.results as? [VNFaceObservation] else { return }
            if observations.count<1{
                AppSupport.state = .stop
            }else{
                guard let observation=observations.max(by: {
                    $0.boundingBox.height<$1.boundingBox.height
                }) else{return}
                
                DispatchQueue.main.async{
                    self.observation=observation
                }
            }
            
            
            
        }
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer)
        do {
            try handler.perform([request])
        } catch {
            print("处理请求失败: \(error)")
        }
    }
}

extension CameraSupport:AVCaptureFileOutputRecordingDelegate{
    func setupCaptureSession() {
            
            
            
            
            
            do {
                
                // 设置音频输入（可选，如需录制声音）
                if let audioDevice = AVCaptureDevice.default(for: .audio) {
                    let audioInput = try AVCaptureDeviceInput(device: audioDevice)
                    if session.canAddInput(audioInput) == true {
                        session.addInput(audioInput)
                    }
                }
                
                movieFileOutput = AVCaptureMovieFileOutput()
                if session.canAddOutput(movieFileOutput!) == true {
                    session.addOutput(movieFileOutput!)
                }
                
                
            } catch {
                //失败
            }
        }
        
        // 开始录制
        func startRecording() {
            guard let movieFileOutput = movieFileOutput, !isRecording else { return }
            
            let outputFileName = UUID().uuidString
            let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("\(outputFileName).mov")
            let outputURL = URL(fileURLWithPath: outputFilePath)
            
            movieFileOutput.startRecording(to: outputURL, recordingDelegate: self)
            isRecording = true
            lastVideoURL = outputURL
        }
        
        // 停止录制
        func stopRecording() {
            if isRecording {
                movieFileOutput?.stopRecording()
                isRecording = false
            }
        }
        
        // 保存视频到相册
        func saveVideoToPhotos() {
            guard let url = lastVideoURL else {//未找到文件
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }) { success, error in
                //已保存
            }
        }
        
        
        func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
            if let error = error {
                //未成功录制，停止
                isRecording = false
            }
        }
        
        // 权限
        static func checkPermissions() async -> Bool {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                return PHPhotoLibrary.authorizationStatus() == .authorized
            case .notDetermined:
                let videoGranted = await AVCaptureDevice.requestAccess(for: .video)
                if videoGranted {
                    let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
                    return status == .authorized
                }
                return false
            default:
                return false
            }
        }
    
}
