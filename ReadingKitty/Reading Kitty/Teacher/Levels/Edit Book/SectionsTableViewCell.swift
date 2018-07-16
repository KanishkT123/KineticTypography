//
//  SectionsTableViewCell.swift
//  Reading Kitty
//
//  Created by cssummer18 on 7/13/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class SectionsTableViewCell: UITableViewCell {
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var sectionText: UITextView!
    @IBOutlet weak var editButton: UIButton!
    
    weak var delegate: SectionsTableViewCellDelegate?
    
    @IBAction func editTapped(_ sender: UIButton) {
        delegate?.editButtonTapped(self)
    }
}

protocol SectionsTableViewCellDelegate : class {
    func editButtonTapped(_ sender: SectionsTableViewCell)
}
