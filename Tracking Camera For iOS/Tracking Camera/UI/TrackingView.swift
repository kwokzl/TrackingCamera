//
//  2.swift
//  Tracking Camera
//
//  Created by Zonlin Kwok on 2025/7/26.
//

import SwiftUI

struct TrackingView: View {
    @State private var shootingTitle = ""
    @State private var aperture = "f/2.8"
    @State private var shutterspeed = "1/125"
    @State private var iso = "100"
    @State private var weatherCondition = 0
    @State private var notes = ""
    @State private var selectedMood = -1
    
    // 天气选项
    let weatherOptions = ["晴朗", "多云", "阴天", "小雨", "大雨"]
    
    // 心情选项
    let moodOptions = ["😊", "😍", "🤔", "😐", "😢"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 标题输入
                VStack(alignment: .leading) {
                    Text("拍摄标题").font(.caption).foregroundColor(.secondary)
                    TextField("输入标题", text: $shootingTitle)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                // 位置和时间
                HStack {
                    VStack(alignment: .leading) {
                        Text("位置").font(.caption).foregroundColor(.secondary)
                        HStack {
                            Image(systemName: "location")
                            Text("北京市朝阳区")
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("时间").font(.caption).foregroundColor(.secondary)
                        HStack {
                            Image(systemName: "clock")
                            Text("10月12日 15:30")
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                
                // 相机参数
                VStack(alignment: .leading) {
                    Text("相机参数").font(.headline)
                    
                    HStack {
                        paramField(title: "光圈", value: $aperture)
                        paramField(title: "快门", value: $shutterspeed)
                        paramField(title: "ISO", value: $iso)
                    }
                }
                
                // 天气条件
                VStack(alignment: .center) {
                    Text("天气条件").font(.headline)
                        .frame(maxWidth:.infinity,alignment: .leading)
                    HStack {
                        ForEach(0..<weatherOptions.count, id: \.self) { index in
                            Button(action: { weatherCondition = index }) {
                                Text(weatherOptions[index])
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(weatherCondition == index ? Color.yellow : Color.gray.opacity(0.1))
                                    .foregroundColor(weatherCondition == index ? .white : .primary)
                                    .cornerRadius(15)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }
                
                
                // 笔记
                VStack(alignment: .leading) {
                    Text("笔记").font(.headline)
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .padding(5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                // 心情
                VStack(alignment: .center) {
                    Text("心情").font(.headline)
                        .frame(maxWidth:.infinity,alignment: .leading)
                    HStack {
                        ForEach(0..<moodOptions.count, id: \.self) { index in
                            Button(action: { selectedMood = index }) {
                                Text(moodOptions[index])
                                    .font(.system(size: 30))
                                    .padding(5)
                                    .background(selectedMood == index ? Color.yellow.opacity(0.2) : Color.clear)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                // 添加照片
                VStack {
                    Button(action: {}) {
                        VStack {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 30))
                            Text("添加照片")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .foregroundColor(.primary)
                }
                
                // 保存按钮
                Button(action: {}) {
                    Text("保存记录")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
            .padding()
        }
    }
    
    // 相机参数输入字段
    func paramField(title: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption).foregroundColor(.secondary)
            TextField(title, text: value)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

#Preview {
    TrackingView()
}
