//
//  AnswerTableViewCell.swift
//  AppQuiz
//
//  Created by Taof on 8/28/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var answerLabel: UILabel!
    var cauTraLoiDung = ""
    var type = Type.test
    var answer: Answer? {
        didSet{
            if let answer = answer {
                answerLabel.text = answer.answer
                selectButton.isSelected = answer.isSelected
                if type == .history {
                    if cauTraLoiDung != answer.answer{
                        answerLabel.textColor = UIColor.red
                    } else {
                        answerLabel.textColor = UIColor.green
                    }
                } else if type == .practice{
                    if answer.isSelected {
                        if cauTraLoiDung != answer.answer{
                            answerLabel.textColor = UIColor.red
                        } else {
                            answerLabel.textColor = UIColor.green
                        }
                    } else {
                        answerLabel.textColor = UIColor.black
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapAction(_ sender: Any) {
        
    }
}
