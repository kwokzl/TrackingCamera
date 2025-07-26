//
//  CameraView.swift
//  Tracking Camera
//
//  Created by Zonlin Kwok on 2025/7/24.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @ObservedObject var avSupport=AppSupport.cameraSupport
    @State var hstate=""
    @State var orientation: UIDeviceOrientation = .portrait
    @State var xOffset:CGFloat=0
    @State var yOffset:CGFloat=0
    var body: some View {
        GeometryReader{geometry in
            
            
            
            
            ZStack(/*alignment:.topLeading*/){
                CameraDisplayer(avCaptureSession: avSupport.session)
//                    .ignoresSafeArea()
                    .frame(width: min(geometry.size.width, geometry.size.height),
                           height: max(geometry.size.width, geometry.size.height))
                    .rotationEffect(getRotationAngle())
                    .offset(x: xOffset,
                            y: yOffset)
                    .position(x: 0,
                              y: 0)
                    .ignoresSafeArea()
                
                
                
                VStack{
                    Spacer()
                    VStack{
                        
                        
                        //                        Text("脸：\(avSupport.observations.count)")
                        
                        //Text("第一个位置：\(avSupport.observations[0].boundingBox)")
                        //Text("第一个大小：Width:\(avSupport.observations[0].boundingBox.width), Height\(avSupport.observations[0].boundingBox.height)")
                        
                        
//                        Text(String(format: "距离：%.1f", distance))
//                        Text("坐标：x=\(maxFace.boundingBox.origin.x), y=\(maxFace.boundingBox.origin.y)")
                        Text(hstate)
                        
                        
                        
                        
                        
                        
                        
                    }
                    .padding()
                    .background(.bar,in: .rect(cornerRadius: 10))
                    
                    
                    
                    
                }
                //            let x = maxFace.boundingBox.origin.x * UIScreen.main.nativeBounds.width
                //            let y = (1 - maxFace.boundingBox.origin.y - maxFace.boundingBox.height) * UIScreen.main.nativeBounds.height
                //            let width = maxFace.boundingBox.width * UIScreen.main.nativeBounds.width
                //            let height = maxFace.boundingBox.height * UIScreen.main.nativeBounds.height
                //            Rectangle()
                //                .fill(.orange)
                //                .opacity(0.5)
                //                .clipShape(.rect(cornerRadius: 10))
                //                .position(x:y,y:x)
                //                .frame(width:width,height:height)
                
                
            }
            .onAppear{
                NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                                orientation = UIDevice.current.orientation
//                                cameraModel.updatePreviewOrientation()
                            }
                            orientation = UIDevice.current.orientation
            }
            .onChange(of:orientation){
                xOffset=getXOffset(geometry: geometry)
                yOffset=getYOffset(geometry: geometry)
            }
            .onChange(of:avSupport.observation){
                MV(ob: avSupport.observation)
            }
            .onChange(of: AppSupport.state){
                hstate=AppSupport.state.rawValue
            }
        }
    }
}

struct CameraDisplayer:UIViewRepresentable{
    let avCaptureSession:AVCaptureSession
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeUIView(context: Context) -> UIView {
        let av=AVCaptureVideoPreviewLayer(session: avCaptureSession)
        let view=UIView(frame: UIScreen.main.bounds)
        av.videoGravity = .resizeAspectFill
        av.frame = view.bounds
        
        view.layer.addSublayer(av)
        
        av.videoGravity = .resizeAspectFill
        
        return view
    }
    
    
}

#Preview {
    CameraView()
}


