//
//  4.swift
//  Tracking Camera
//
//  Created by Zonlin Kwok on 2025/7/26.
//

import SwiftUI

struct CommunityView: View {
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 主内容区
            VStack(spacing: 0) {
                // 顶部栏
                
                
                
                
                // 社区帖子列表
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(1...4, id: \.self) { _ in
                            postCard
                        }
                        Spacer().frame(height: 80)
                    }
                    .padding()
                }
            }
            
            // 悬浮发布按钮
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.yellow)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding([.trailing, .bottom], 16)
                }
                .padding()
                .padding(.bottom,65)
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle("拍摄社区")
    }
    
    // 帖子卡片
    var postCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 用户信息
            HStack {
                Circle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: 36, height: 36)
                    .overlay(Image(systemName: "person").foregroundColor(.secondary))
                
                VStack(alignment: .leading) {
                    Text("摄影爱好者")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("1小时前")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            
            // 内容
            Text("分享一张拍摄于黄金时间的风景照，光线很完美")
                .font(.subheadline)
            
            // 图片
            Rectangle()
                .fill(Color(UIColor.systemGray5))
                .frame(height: 180)
                .cornerRadius(12)
                .overlay(Image(systemName: "photo").foregroundColor(.secondary))
            
            // 互动
            HStack {
                Label("68", systemImage: "heart")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Label("23", systemImage: "message")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("f/8 · 1/250s · ISO 100")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    
    
    // 标签图标
    func tabIcon(_ index: Int) -> String {
        let icons = ["house", "camera", "rectangle.stack", "bubble.left.and.bubble.right.fill", "mappin.and.ellipse"]
        return icons[index]
    }
    
    // 标签标题
    func tabTitle(_ index: Int) -> String {
        let titles = ["主页", "跟踪拍摄", "跟拍记录", "拍摄社区", "定位拍摄"]
        return titles[index]
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}
