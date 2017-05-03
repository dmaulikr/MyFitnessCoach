//
//  SecondViewController.swift
//  MyFitnessCoach
//
//  Created by Andrew Meng on 2017-03-25.
//  Copyright © 2017 Andrew Meng. All rights reserved.
//

import UIKit

class RoutinesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated : Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

}

