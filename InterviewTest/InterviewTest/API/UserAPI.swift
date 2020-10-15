//
//  UserAPI.swift
//  InterviewTest
//
//  Created by Nguyễn Đức Thịnh on 10/8/20.
//  Copyright © 2020 Duc Thinh. All rights reserved.
//

import Foundation
class UserAPI: BaseAPIServiceObject {
    func getListDiary(completion: @escaping (_ listDiary: [Diary], _ error: Error?) -> Void) {
        params.removeAll()
        let urlString = BASE_URL
        requestManager.startRequestWithoutAuth(url: urlString, method: "GET", params: params) { (json, error) in
            if let error = error {
                completion([], error)
            } else {
                guard let dict = json as? [JSON] else { return }
                var listDiary: [Diary] = []
                for object in dict {
                    guard let data = Diary.init(dictionary: object) else { return }
                    listDiary.append(data)
                }
                completion(listDiary, nil)
            }
        }
    }
}
