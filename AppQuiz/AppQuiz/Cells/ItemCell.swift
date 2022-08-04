//
//  ItemCell.swift
//  AppQuiz
//
//  Created by Taof on 8/28/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var numbersQuestionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    // khai báo một biến start kiểu closure
    var start: (() -> Void)?
    var type: Type = .test
    var soCauDung: Int = 0
    
    var item: Collection?{
        didSet{
            if let item = item {
                levelLabel.text = item.level
                timeLabel.text = String(item.time)
                subjectLabel.text = item.subject
                
                switch type {
                case .test:
                    timeLabel.text = String(item.time)
                case .history:
                    for question in item.questions {
                        for answer in question.answers{
                            if answer.answer == question.answer && answer.isSelected{ // đặt tên cho đúng,
                                soCauDung += 1
                            }
                            // nếu câu sai, text phải màu đỏ
                        }
                        timeLabel.text = " Đúng \(soCauDung)/\(question.answers.count) câu"
                    }
                case .practice:
                    // hiển thị tổng số câu
                    timeLabel.text = String("0/\(item.questions.count)")
                default:
                    break
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func startDidpress(_ sender: Any) {
        
        // gọi closure
        // ?: có đối tượng nào lắng nghe (hứng start) thì mới k nil
        start?()
    }
}
