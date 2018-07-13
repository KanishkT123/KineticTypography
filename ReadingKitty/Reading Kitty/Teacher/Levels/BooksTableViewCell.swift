//
//  BooksTableViewCell.swift
//  Reading Kitty
//
//  Created by cssummer18 on 7/13/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class BooksTableViewCell: UITableViewCell {
    @IBOutlet weak var book: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    weak var delegate: BooksTableViewCellDelegate?
    
    @IBAction func editTapped(_ sender: UIButton) {
        delegate?.editButtonTapped(self)
    }
}

protocol BooksTableViewCellDelegate : class {
    func editButtonTapped(_ sender: BooksTableViewCell)
}
