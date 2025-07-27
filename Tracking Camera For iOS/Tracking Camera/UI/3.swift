//
//  3.swift
//  Tracking Camera
//
//  Created by Zonlin Kwok on 2025/7/26.
//

import SwiftUI

struct RecordsView: View {
    @State private var searchText = ""
    @State private var selectedFilter = 0
    
    // 筛选选项
    let filterOptions = ["全部", "最近", "风景", "城市", "人像"]
    
    // 示例数据
    let records = [
        (title: "金色日落", location: "密云水库", date: "今天", params: "f/8 · 1/250s · ISO 100"),
        (title: "城市夜景", location: "北京CBD", date: "昨天", params: "f/2.8 · 1/30s · ISO 800"),
        (title: "雨后清晨", location: "颐和园", date: "3天前", params: "f/11 · 1/125s · ISO 200")
    ]
    
    var body: some View {
        VStack(spacing: 15) {
            
            // 记录列表
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(0..<records.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            // 照片
                            ZStack(alignment: .bottomLeading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 180)
                                    .cornerRadius(10)
                                    .overlay(Image(systemName: "photo"))
                                
                                // 位置和日期
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(records[index].location)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                        Text(records[index].date)
                                            .font(.caption2)
                                    }
                                    .padding(8)
                                    .background(Color.black.opacity(0.5))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .padding(8)
                                }
                            }
                            
                            // 标题和参数
                            VStack(alignment: .leading, spacing: 5) {
                                Text(records[index].title)
                                    .font(.headline)
                                Text(records[index].params)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(5)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 5)
                            .padding(.bottom, 5)
                        }
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical,20)
            }
        }
        .navigationTitle("拍摄记录")
        .toolbar{
            Button(action:{}){
                Image(systemName: "plus")
            }
        }
    }
}

#Preview {
    RecordsView()
}
