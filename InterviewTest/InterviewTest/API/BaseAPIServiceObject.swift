//
//  BaseAPIServiceObject.swift
//  InterviewTest
//
//  Created by Nguyễn Đức Thịnh on 10/8/20.
//  Copyright © 2020 Duc Thinh. All rights reserved.
//

import Foundation
class BaseAPIServiceObject: NSObject {
    var requestManager = RequestManager.init()
    let BASE_URL:String = "https://private-ba0842-gary23.apiary-mock.com/notes"
    var params = [String:Any]()
}
