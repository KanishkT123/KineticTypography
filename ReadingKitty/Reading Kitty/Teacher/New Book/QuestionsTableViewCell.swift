//
//  QuestionsTableViewCell.swift
//  Reading Kitty
//
//  Created by cssummer18 on 7/5/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class QuestionsTableViewCell: UITableViewCell {
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var device: UILabel!
    @IBOutlet weak var answers: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: QuestionsTableViewCellDelegate?
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        delegate?.deleteButtonTapped(self)
    }
}

protocol QuestionsTableViewCellDelegate : class {
    func deleteButtonTapped(_ sender: QuestionsTableViewCell)
}
