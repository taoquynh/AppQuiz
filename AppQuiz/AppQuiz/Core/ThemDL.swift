//
//  ThemDL.swift
//  AppQuiz
//
//  Created by Taof on 8/28/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit
import Firebase

class ThemDL: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addDuLieu()
    }
    
    func addDuLieu(){
        
        let db = Firestore.firestore()
        
        let question1 = Question(question: "Từ nào dưới đây có tiếng đồng không có nghĩa là “cùng”?", note: "từ đồng nghĩa", answer: "Thần đồng", answers: [Answer(answer: "Đồng hương", isSelected: false),
                                 Answer(answer: "Thần đồng", isSelected: false),
                                 Answer(answer: "Đồng nghĩa", isSelected: false),
                                 Answer(answer: "Đồng chí", isSelected: false)])
        
        let question2 = Question(question: "Những cặp từ nào dưới đây cùng nghĩa với nhau?", note: "từ đồng nghĩa", answer: "Luyện tập - rèn luyện", answers: [Answer(answer: "Leo - chạy", isSelected: false),
                                 Answer(answer: "Chịu đựng - rèn luyện", isSelected: false),
                                 Answer(answer: "Luyện tập - rèn luyện", isSelected: false),
                                 Answer(answer: "Đứng - ngồi", isSelected: false) ])
        
        let question3 = Question(question: "Dòng nào dưới đây nêu đúng nghĩa của từ tự trọng?", note: "", answer: "Coi trọng và giữ gìn phầm giá của mình", answers: [Answer(answer: "Tin vào bản thân mình", isSelected: false),
                                           Answer(answer: "Đánh giá mình quá cao và coi thường ngừoi khác", isSelected: false),
                                           Answer(answer: "Coi trọng mình và xem thường người", isSelected: false),
                                           Answer(answer: "Coi trọng và giữ gìn phầm giá của mình", isSelected: false)])
        
        let question4 = Question(question: "Câu nào dưới đây dùng dấu hỏi chưa đúng?", note: "A là câu đề  ", answer: "Hãy giữ trật tự?", answers: [Answer(answer: "Hãy giữ trật tự?", isSelected: false),
                                           Answer(answer: "Nhà bạn ở đâu?", isSelected: false),
                                           Answer(answer: "Vì sao hôm qua bạn nghỉ học?", isSelected: false),
                                           Answer(answer: "Một tháng có bao nhiêu ngày hả chị?", isSelected: false)])
        
        let question5 = Question(question: "Câu nào dưới đây dùng dấu phẩy chưa đúng?", note: "Hoa huệ, hoa lan tỏa hương thơm ngát.", answer: "Hoa huệ hoa lan, tỏa hương thơm ngát.", answers: [Answer(answer: "Mùa thu, tiết trời mát mẻ.", isSelected: false),
                                           Answer(answer: "Hoa huệ hoa lan, tỏa hương thơm ngát.", isSelected: false),
                                           Answer(answer: "Từng đàn kiến đen, kiến vàng hành quân đầy đường.", isSelected: false),
                                           Answer(answer: "Nam thích đá cầu, cờ vua", isSelected: false)])
        
        let question6 = Question(question: "Thành ngữ, tục ngữ nào sau đây ca ngợi đạo lý thủy chung, luôn biết ơn những người có công với nước với dân?", note: "Uống nước nhớ nguồn ý rằng con người phải nhớ đến nguồn cội", answer: "Uống nước nhớ nguồn", answers: [Answer(answer: "Muôn người như một", isSelected: false),
                                           Answer(answer: "Chịu thương, chịu khó", isSelected: false),
                                           Answer(answer: "Dám nghĩ dám làm", isSelected: false),
                                           Answer(answer: "Uống nước nhớ nguồn", isSelected: false)])
        
        let collection1 = Collection(level: "Level 1", subject: "Tiếng Việt", time: 60, questions: [question1, question2])
        let collection2 = Collection(level: "Level 2", subject: "Tiếng Việt", time: 50, questions: [question3, question4])
        let collection3 = Collection(level: "Level 3", subject: "Tiếng Việt", time: 40, questions: [question5, question6])
        
        let collections = [collection1, collection2, collection3]
        
        for item in collections {
            db.collection("tests").addDocument(data: item.dictionary)
        }
    }
}
