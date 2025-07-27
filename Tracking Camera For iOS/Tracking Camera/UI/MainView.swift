//
//  123.swift
//  Tracking Camera
//
//  Created by Zonlin Kwok on 2025/7/25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @Binding var selection:Int
    var body: some View {
        ZStack(alignment: .bottom) {
            // 主内容区
            VStack(spacing: 0) {
                // 顶部导航栏
                /*
                HStack {
                    
                    
                    Spacer()
                    
                    Circle()
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(Color(UIColor.systemGray))
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)
                */
                // 主页内容
                ScrollView {
                    VStack(spacing: 24) {
                        // 欢迎区
                        VStack(alignment: .leading, spacing: 4) {
                            Text("你好，摄影师")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("今天是拍摄的好天气")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        // 快速开始跟踪按钮
                        Button(action: {
                            // 跳转到跟踪拍摄页面
                            
                        }) {
                            HStack {
                                Image(systemName: "camera.fill")
                                    .font(.title2)
                                
                                Text("开始新的拍摄旅程")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.yellow, Color.orange.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(color: Color.yellow.opacity(0.3), radius: 10, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                        
                        // 近期跟拍记录
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("近期跟拍记录")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Button(action: {
                                    selection=1
                                }) {
                                    Text("查看全部")
                                        .font(.subheadline)
                                        .foregroundColor(Color.yellow)
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    // 跟拍记录卡片
                                    ForEach(0..<3) { _ in
                                        VStack(alignment: .leading, spacing: 8) {
                                            // 图片
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color(UIColor.systemGray5))
                                                .frame(width: 140, height: 100)
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .foregroundColor(Color(UIColor.systemGray3))
                                                )
                                            
                                            Text("黄金日落")
                                                .font(.callout)
                                                .fontWeight(.medium)
                                            
                                            Text("f/2.8 · 1/125s · ISO 100")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                        }
                                        .frame(width: 140)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 社区精选
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("社区精选")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                NavigationLink(destination:{CommunityView()}){
                                    Text("更多")
                                        .font(.subheadline)
                                        .foregroundColor(Color.yellow)
                                }
                            }
                            
                            VStack(spacing: 16) {
                                // 社区帖子
                                ForEach(0..<2) { _ in
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack(spacing: 8) {
                                            Circle()
                                                .fill(Color(UIColor.systemGray5))
                                                .frame(width: 36, height: 36)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("摄影达人")
                                                    .font(.callout)
                                                    .fontWeight(.medium)
                                                
                                                Text("2小时前")
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            Spacer()
                                        }
                                        
                                        Text("分享一组使用长焦镜头拍摄的城市日落照片，非常满意这次的光线效果！")
                                            .font(.subheadline)
                                            .lineLimit(2)
                                        
                                        // 图片
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(UIColor.systemGray5))
                                            .frame(height: 180)
                                            .overlay(
                                                Image(systemName: "photo")
                                                    .foregroundColor(Color(UIColor.systemGray3))
                                            )
                                        
                                        HStack(spacing: 16) {
                                            Label("128", systemImage: "heart")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            
                                            Label("36", systemImage: "text.bubble")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            
                                            Spacer()
                                        }
                                    }
                                    .padding(16)
                                    .background(Color(UIColor.systemBackground))
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 附近推荐拍摄地
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("附近推荐拍摄地")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("查看地图")
                                        .font(.subheadline)
                                        .foregroundColor(Color.yellow)
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    // 地点卡片
                                    ForEach(0..<4) { _ in
                                        VStack(alignment: .leading, spacing: 8) {
                                            // 图片
                                            ZStack(alignment: .topTrailing) {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color(UIColor.systemGray5))
                                                    .frame(width: 160, height: 100)
                                                    .overlay(
                                                        Image(systemName: "mountain.2.fill")
                                                            .foregroundColor(Color(UIColor.systemGray3))
                                                    )
                                                
                                                Text("0.8km")
                                                    .font(.caption2)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 3)
                                                    .background(Color.black.opacity(0.6))
                                                    .foregroundColor(.white)
                                                    .cornerRadius(10)
                                                    .padding(8)
                                            }
                                            
                                            Text("城市天际线")
                                                .font(.callout)
                                                .fontWeight(.medium)
                                            
                                            HStack(spacing: 4) {
                                                ForEach(0..<5) { i in
                                                    Image(systemName: i < 4 ? "star.fill" : "star")
                                                        .font(.caption2)
                                                        .foregroundColor(i < 4 ? Color.yellow : Color.secondary)
                                                }
                                                
                                                Text("(24)")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                    .padding(.leading, 4)
                                            }
                                        }
                                        .frame(width: 160)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 底部间距
                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(.vertical, 16)
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(UIColor.systemBackground), Color(UIColor.systemBackground).opacity(0.95)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // 底部导航栏
//            HStack(spacing: 0) {
//                ForEach(0..<5) { index in
//                    Button(action: {
//                        selectedTab = index
//                    }) {
//                        VStack(spacing: 4) {
//                            Image(systemName: getTabIcon(for: index))
//                                .font(.system(size: 20))
//                            
//                            Text(getTabTitle(for: index))
//                                .font(.caption2)
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 8)
//                        .foregroundColor(selectedTab == index ? Color.yellow : Color.secondary)
//                    }
//                }
//            }
//            .padding(.horizontal, 16)
//            .padding(.top, 12)
//            .padding(.bottom, 24)
//            .background(
//                RoundedRectangle(cornerRadius: 24)
//                    .fill(Color(UIColor.systemBackground))
//                    .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: -4)
//            )
//            .offset(y: -8)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // 获取对应标签页的图标
    private func getTabIcon(for index: Int) -> String {
        switch index {
        case 0:
            return "house.fill"
        case 1:
            return "camera"
        case 2:
            return "rectangle.stack"
        case 3:
            return "bubble.left.and.bubble.right"
        case 4:
            return "mappin.and.ellipse"
        default:
            return "questionmark"
        }
    }
    
    // 获取对应标签页的标题
    private func getTabTitle(for index: Int) -> String {
        switch index {
        case 0:
            return "主页"
        case 1:
            return "跟踪拍摄"
        case 2:
            return "跟拍记录"
        case 3:
            return "拍摄社区"
        case 4:
            return "定位拍摄"
        default:
            return ""
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(selection: .constant(0))
    }
}
