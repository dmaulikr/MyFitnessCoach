//
//  FirstViewController.swift
//  MyFitnessCoach
//
//  Created by Andrew Meng on 2017-03-25.
//  Copyright © 2017 Andrew Meng. All rights reserved.
//

import UIKit

let standardFont = "AppleGothic"

class HomeVC: UIViewController, WeeklyScheduleViewDelegate {
    
    lazy var scheduleView : WeeklyScheduleView = {
        let view = WeeklyScheduleView()
        return view
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: standardFont, size: 26)
        label.text = "Your Progress This Week"
        return label
    }()

    lazy var checkInCountLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: standardFont, size: 26)
        return label
    }()
    
    lazy var editScheduleButton : UIButton = {
        let button = UIButton()
        //let image = UIImage(named: "homeTabIcon")
        //button.setBackgroundImage(image, for: UIControlState.normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(HomeVC.editScheduleAction), for: .touchUpInside)
        return button
    }()
    
    lazy var checkInButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(HomeVC.checkInAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xMargin : CGFloat = 20
        var y : CGFloat = 50
        
        titleLabel.frame = CGRect(x: xMargin, y: y, width: view.frame.width - 2 * xMargin, height: 30)
        view.addSubview(titleLabel)
        
        y = y + titleLabel.frame.maxY
        
        editScheduleButton.frame = CGRect(x: xMargin, y: y + 50, width: view.frame.width - 2 * xMargin, height: 50)
        view.addSubview(editScheduleButton)
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
    }
    
    func editScheduleAction() {
        print("edit schedule button pressed")
    }
    
    func checkInAction() {
        print("check in action pressed")
    }
    
}

