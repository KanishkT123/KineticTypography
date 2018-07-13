//
//  AnswersTableViewCell.swift
//  Reading Kitty
//
//  Created by cssummer18 on 7/13/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class AnswersTableViewCell: UITableViewCell {
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: AnswersTableViewCellDelegate?
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        delegate?.deleteButtonTapped(self)
    }
}

protocol AnswersTableViewCellDelegate : class {
    func deleteButtonTapped(_ sender: AnswersTableViewCell)
}
