//
//  Diary.swift
//  InterviewTest
//
//  Created by Nguyễn Đức Thịnh on 10/8/20.
//  Copyright © 2020 Duc Thinh. All rights reserved.
//

import Foundation
import RealmSwift
typealias JSON = Dictionary<AnyHashable, Any>
class Diary : Object {
    @objc dynamic var id : String?
    @objc dynamic var title: String?
    @objc dynamic var content: String?
    @objc dynamic var date: String?
    required init() {
        id = ""
        title = ""
        content = ""
        date = ""
    }
    init?(dictionary: JSON) {
        self.id = dictionary["id"] as? String
        self.title = dictionary["title"] as? String
        self.content =  dictionary["content"] as? String
        self.date = dictionary["date"] as? String
    }
    
    
    
}

