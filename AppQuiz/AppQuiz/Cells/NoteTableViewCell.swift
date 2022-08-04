//
//  NoteTableViewCell.swift
//  AppQuiz
//
//  Created by Taof on 8/30/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.isHidden = true
        titleLabel.isHidden = true
        noteLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
