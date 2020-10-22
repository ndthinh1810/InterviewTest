//
//  RequestManager.swift
//  InterviewTest
//
//  Created by Nguyễn Đức Thịnh on 10/8/20.
//  Copyright © 2020 Duc Thinh. All rights reserved.
//

import Foundation
class RequestManager: NSObject {
    let session = URLSession.shared
    func startRequestWithoutAuth(url: String, method: String, params: [String:Any], completion: @escaping(Any?, Error?) -> Void) {
        guard let serviceUrl = URL(string: url) else { return }
        let parameterDictionary = params
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = method
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        
        if method != "GET" {
            request.httpBody = httpBody
        }
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completion(json, nil)
                    print(json)
                } catch {
                    completion(nil, error)
                    print(error)
                }
            }
        }.resume()
    }
    
}
