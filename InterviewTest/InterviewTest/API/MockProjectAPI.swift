//
//  MockProjectAPI.swift
//  InterviewTest
//
//  Created by Nguyễn Đức Thịnh on 10/8/20.
//  Copyright © 2020 Duc Thinh. All rights reserved.
//

import Foundation
class MockProjectAPI {
    static let shared = MockProjectAPI()
    private var userAPI = UserAPI()
    
    private init() {
    
    }
        
    func getUserAPI() -> UserAPI {
        return userAPI
    }
}
