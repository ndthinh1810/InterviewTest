//
//  Diary.swift
//  InterviewTest
//
//  Created by Nguyễn Đức Thịnh on 10/8/20.
//  Copyright © 2020 Duc Thinh. All rights reserved.
//

import Foundation
typealias JSON = Dictionary<AnyHashable, Any>
class Diary {
    var id: Int?
    var title: String?
    var content: String?
    var date: String?
    
    init?(dictionary: JSON) {
        self.id = dictionary["id"] as? Int
        self.title = dictionary["title"] as? String
        self.content =  dictionary["content"] as? String
        self.date = dictionary["date"] as? String
    }
    
}

