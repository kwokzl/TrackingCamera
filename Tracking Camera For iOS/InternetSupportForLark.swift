//
//  InternetSupportForLark.swift
//  Tracking Camera
//
//  Created by Zonlin Kwok on 2025/7/26.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct HTTPRequest {
    static func request(
        url: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        body: [String: Any]? = nil,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // 设置通用请求头
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 添加自定义请求头
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // 设置请求体
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        // 创建数据任务
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 500, userInfo: nil)))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "HTTP error \(httpResponse.statusCode)", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 500, userInfo: nil)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    completion(.success(json))
                } else if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                    completion(.success(["data": jsonArray]))
                } else {
                    completion(.failure(NSError(domain: "Invalid JSON format", code: 500, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

// 使用示例
func fetchData() {
    // GET请求示例
    HTTPRequest.request(url: "https://api.example.com/data") { result in
        switch result {
        case .success(let json):
            print("GET成功: \(json)")
        case .failure(let error):
            print("GET失败: \(error.localizedDescription)")
        }
    }
    
    // POST请求示例
    let postData = ["name": "John", "age": 30] as [String : Any]
    HTTPRequest.request(
        url: "https://api.example.com/submit",
        method: .post,
        body: postData
    ) { result in
        switch result {
        case .success(let json):
            print("POST成功: \(json)")
        case .failure(let error):
            print("POST失败: \(error.localizedDescription)")
        }
    }
}    
