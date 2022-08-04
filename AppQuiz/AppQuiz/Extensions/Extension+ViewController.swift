//
//  Extension+ViewController.swift
//  AppQuiz
//
//  Created by Taof on 8/28/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setupSlideMenuItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "menu")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func removeSlideMenuItem(){
        self.navigationItem.leftBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
    }
}
