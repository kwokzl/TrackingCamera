//
//  CameraView.swift
//  Tracking Camera
//
//  Created by Zonlin Kwok on 2025/7/24.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @ObservedObject var avSupport=CameraSupport()
    var body: some View {
        CameraDisplayer(avCaptureSession: avSupport.session)
    }
}

struct CameraDisplayer:UIViewRepresentable{
    let avCaptureSession:AVCaptureSession
    func updateUIView(_ uiView: UIView, context: Context) {
        return;
    }
    
    func makeUIView(context: Context) -> UIView {
        let av=AVCaptureVideoPreviewLayer(session: avCaptureSession)
        let view=UIView(frame: UIScreen.main.bounds)
        av.videoGravity = .resizeAspectFill
        av.frame = view.bounds
        
        view.layer.addSublayer(av)
        return view
    }
    
    
}

#Preview {
    CameraView()
}

