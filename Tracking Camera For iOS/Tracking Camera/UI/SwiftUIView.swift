//
//  SwiftUIView.swift
//  Tracking Camera
//
//  Created by Zonlin Kwok on 2025/7/25.
//

import SwiftUI

struct SwiftUIView: View {
    @State var selection=0
    var body: some View {
        TabView(selection:$selection){
            Tab("主页", systemImage: "house.fill",value: 0) {
                NavigationView{
                    MainView(selection: $selection)
                }
                    
            }
//            Tab("TrackingView",systemImage: ""){
//                TrackingView()
//            }
            Tab("拍摄记录",systemImage: "",value: 1){
                NavigationView{
                    RecordsView()
                }
            }
        }
       
    }
}

#Preview {
    SwiftUIView()
}
