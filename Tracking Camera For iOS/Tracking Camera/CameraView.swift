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
        ZStack{
            CameraDisplayer(avCaptureSession: avSupport.session)
                .ignoresSafeArea()
            if avSupport.observations.count>0{
//                Rectangle()
//                    .frame(width:100,height:100)
//                    .offset(avSupport.observations[0].boundingBox.size)
                    
            }
            VStack{
                Spacer()
                VStack{
                    Text("脸：\(avSupport.observations.count)")
                    if avSupport.observations.count>0{
                        //Text("第一个位置：\(avSupport.observations[0].boundingBox)")
                        //Text("第一个大小：Width:\(avSupport.observations[0].boundingBox.width), Height\(avSupport.observations[0].boundingBox.height)")
                        let maxFace=avSupport.observations.max(by: { a, b in
                            return a.boundingBox.height < b.boundingBox.height
                        })
                        let pixelHeight = (maxFace?.boundingBox.height ?? 0) * CGFloat(UIScreen.main.nativeBounds.height)
                                
                        let focalLength_px: CGFloat = 1500
                                
                        let realFaceHeight: CGFloat = 0.15
                        
                        let distance = (realFaceHeight * focalLength_px) / pixelHeight
                        
                        
                        Text(String(format: "距离：%.1f", distance))
                    }
                }
                .padding()
                .background(.bar,in: .rect(cornerRadius: 10))
                
                
                
            }
            
        }
        
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

