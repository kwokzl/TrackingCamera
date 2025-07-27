////
////  ContentView.swift
////  Tracking Camera
////
////  Created by Zonlin Kwok on 2025/7/24.
////
//
//import SwiftUI
//import AVFoundation
//import Vision
//
//
//
//// MARK: - CameraView（SwiftUI 层）
//struct CameraView: View {
//    @StateObject private var vm = CameraViewModel()
//    
//    var body: some View {
//        ZStack {
//            CameraPreview(session: vm.session)
//                .overlay(
//                    VStack {
//                        Spacer()
//                        Text(vm.distanceText)
//                            .font(.largeTitle.bold())
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.black.opacity(0.5))
//                            .cornerRadius(12)
//                            .padding(.bottom, 40)
//                    }
//                )
//        }
//        .onAppear { vm.start() }
//        .onDisappear { vm.stop() }
//    }
//}
//
//// MARK: - CameraPreview（UIViewRepresentable）
//struct CameraPreview: UIViewRepresentable {
//    let session: AVCaptureSession
//    
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView(frame: UIScreen.main.bounds)
//        let preview = AVCaptureVideoPreviewLayer(session: session)
//        preview.videoGravity = .resizeAspectFill
//        preview.frame = view.bounds
//        view.layer.addSublayer(preview)
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {}
//}
//
//// MARK: - CameraViewModel（业务逻辑）
//final class CameraViewModel: NSObject, ObservableObject {
//    private let sessionQueue = DispatchQueue(label: "session")
//    let session = AVCaptureSession()
//    
//    @Published var distanceText = "未检测到人脸"
//    
//    private var requests = [VNRequest]()
//    
//    override init() {
//        super.init()
//        setupCamera()
//        setupVision()
//    }
//    
//    func start() {
//        sessionQueue.async { [weak self] in
//            self?.session.startRunning()
//        }
//    }
//    
//    func stop() {
//        sessionQueue.async { [weak self] in
//            self?.session.stopRunning()
//        }
//    }
//    
//    private func setupCamera() {
//        session.sessionPreset = .photo
//        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
//              let input = try? AVCaptureDeviceInput(device: device),
//              session.canAddInput(input),
//              let output = createOutput() else {
//            fatalError("摄像头配置失败")
//        }
//        session.addInput(input)
//        session.addOutput(output)
//    }
//    
//    private func createOutput() -> AVCaptureVideoDataOutput? {
//        let output = AVCaptureVideoDataOutput()
//        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video"))
//        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
//        return output
//    }
//    
//    private func setupVision() {
//        let request = VNDetectFaceRectanglesRequest { [weak self] req, _ in
//            self?.handleFaces(req)
//        }
//        requests = [request]
//    }
//    
//    private func handleFaces(_ request: VNRequest) {
//        guard let results = request.results as? [VNFaceObservation], !results.isEmpty else {
//            DispatchQueue.main.async { self.distanceText = "未检测到人脸" }
//            return
//        }
//        
//        // 取最大的人脸
//        guard let face = results.max(by: { $0.boundingBox.height < $1.boundingBox.height }) else { return }
//        
//        // 传感器方向为纵向，所以高度对应 boundingBox.height
//        let pixelHeight = face.boundingBox.height * CGFloat(UIScreen.main.nativeBounds.height)
//        
//        // 经验焦距（可替换为精确计算）
//        let focalLength_px: CGFloat = 1500
//        
//        // 真实人脸平均高度 0.15 m
//        let realFaceHeight: CGFloat = 0.15
//        
//        let distance = (realFaceHeight * focalLength_px) / pixelHeight
//        
//        DispatchQueue.main.async {
//            self.distanceText = String(format: "距离 ≈ %.1f m", distance)
//        }
//    }
//}
//
//extension CameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput,
//                       didOutput sampleBuffer: CMSampleBuffer,
//                       from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//        
//        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
//        do {
//            try handler.perform(requests)
//        } catch {
//            print("Vision 请求失败：\(error)")
//        }
//    }
//}
//
//#Preview{
//    CameraView()
//}
