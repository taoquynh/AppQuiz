//
//  Collections.swift
//  AppQuiz
//
//  Created by Taof on 8/28/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import Foundation

struct JSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    // đoạn này sẽ convert dữ liệu từ object thành dictionary
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
}

// collection là bộ đề, nhiều bộ đề là nhiều collection
struct Collection: Codable{
    // level của bộ đề
    let level: String
    // chủ đề của bộ đề
    let subject: String
    // thời gian làm bộ đề
    let time: Int
    // mảng câu hỏi có trong bộ đề
    let questions: [Question]
}

struct Question: Codable {
    // câu hỏi
    let question: String
    // giải thích
    let note: String
    // câu trả lời đúng
    let answer: String
    // mảng đáp án của câu hỏi
    var answers: [Answer]
}

// khai báo struct answer
class Answer: Codable {
    // đáp án
    var answer: String = ""
    // check đáp án này có được chọn không
    var isSelected: Bool = false
    
    init(answer: String, isSelected: Bool) {
        self.answer = answer
        self.isSelected = isSelected
    }
}

