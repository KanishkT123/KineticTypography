//
//  TableSegue.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/27/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class TableSegue: UIStoryboardSegue {
    override func perform() {
        let source = self.source
        let destination = self.destination
        
        //source.view.superview?.insertSubview(destination.view, aboveSubview: source.view.superview!)
        source.view.superview?.insertSubview(destination.view, at: 0)
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {destination.view.transform = CGAffineTransform(translationX: 0, y: 0)},
                       completion: {finished in source.present(destination, animated: false, completion: nil)})
//        source.present(destination,
//                       animated: false,
//                       completion: nil)
    }
}
