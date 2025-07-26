//
//  SwiftUIView.swift
//  Tracking Camera
//
//  Created by Zonlin Kwok on 2025/7/25.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        ScrollView{
            HStack{
                VStack(alignment:.leading,spacing: 10){
                    Text("你好，摄影师")
                        .font(.title)
                    Text("2023年11月8日")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image("alert")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
                
            }.padding()
            VStack(alignment:.leading,spacing:20){
                VStack(alignment:.leading,spacing:10){
                    Text("开启新的拍摄旅程")
                        
                        .font(.title3)
                    Text("记录你的跟踪拍摄，捕捉精彩瞬间")
                        .font(.subheadline)
                }
                Button(action:{}){
                    HStack{
                        Text("立即开始跟踪拍摄")
                            .bold()
                        Image(systemName: "arrow.right")
                            .bold()
                    }
                }
                .padding()
                .background(.white,in:.rect(cornerRadius: 999))
                .buttonStyle(.plain)
                .foregroundStyle(.blue)
            }
            .padding()
            
            .frame(maxWidth:.infinity,alignment: .leading)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color(red:1, green: 1, blue: 0.8)]), startPoint: .bottomLeading, endPoint: .topTrailing),in:.rect(cornerRadius: 20))
            .padding()
            Text("近期拍摄记录")
                .frame(maxWidth:.infinity,alignment: .leading)
                .padding()
                .bold()
            VStack{
                
            }
            
            
        }
       
    }
}

#Preview {
    SwiftUIView()
}
