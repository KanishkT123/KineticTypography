//
//  BackwardSegue.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/26/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

class BackwardSegue: UIStoryboardSegue {
    override func perform() {
        let source = self.source
        let destination = self.destination
        
        source.view.superview?.insertSubview(destination.view, belowSubview: source.view)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {source.view.transform = CGAffineTransform(translationX: source.view.frame.size.width, y: 0)},
                       completion: {finished in source.present(destination, animated: false, completion: nil)})
    }
}
