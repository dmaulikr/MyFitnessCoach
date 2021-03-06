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
    
    private lazy var scheduleView : WeeklyScheduleView = {
        let view = WeeklyScheduleView()
        return view
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: standardFont, size: 20)
        label.text = "Your Progress This Week"
        return label
    }()
    
    private lazy var instructionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: standardFont, size: 14)
        label.text = "Tap on a day to view the routine."
        return label
    }()

    private lazy var checkInCountLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: standardFont, size: 14)
        return label
    }()
    
    private lazy var currentWorkoutLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: standardFont, size: 20)
        return label
    }()
    
    private lazy var workoutContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    private lazy var editScheduleButton : UIButton = {
        let button = UIButton()
        //let image = UIImage(named: "homeTabIcon")
        //button.setBackgroundImage(image, for: UIControlState.normal)
        //button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(HomeVC.editScheduleAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var checkInButton : UIButton = {
        let button = UIButton()
        //button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(HomeVC.checkInAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let xMargin : CGFloat = 20
        var y : CGFloat = 50
        
        let checkInsForWeek : [Date]? = getCheckInsForLast(timeFrame: TimeInterval(7 * 24 * 3600))
        
        titleLabel.frame = CGRect(x: xMargin, y: y, width: view.frame.width - 2 * xMargin, height: 30)
        view.addSubview(titleLabel)
        
        y = y + titleLabel.frame.height + 10
        
        instructionLabel.frame = CGRect(x: xMargin, y: y, width: screenWidth - 2 * xMargin, height: 20)
        view.addSubview(instructionLabel)
        
        y = y + instructionLabel.frame.height
        
        // Weekly Schedule View
        
        let weekCalendarView = WeeklyScheduleView(frame: CGRect(x: xMargin, y: y, width: screenWidth - 40, height: screenHeight / 9))
        weekCalendarView.schedule = DMM.getSchedule()
        weekCalendarView.checkedInDates = DMM.getCheckInDates()
        view.addSubview(weekCalendarView)
        
        y = y + weekCalendarView.frame.height + 10
        
        // Check in Count Label
        
        checkInCountLabel.frame = CGRect(x: xMargin, y: y, width: screenWidth - 2 * xMargin, height: 20)
        checkInCountLabel.text = "In the past 7 days, you have checked in \(checkInsForWeek?.count ?? 0) times."
        view.addSubview(checkInCountLabel)
        
        y = y + checkInCountLabel.frame.height + 10
        
        // Today's Workout Zone
        
        currentWorkoutLabel.frame = CGRect(x: xMargin, y: y, width: screenWidth - 2 * xMargin, height: 30)
        currentWorkoutLabel.text = "Today's Scheduled Workout Routine"
        view.addSubview(currentWorkoutLabel)
        
        y = y + currentWorkoutLabel.frame.height + 10
        
        let workoutTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeVC.workoutTapAction))
        workoutContainerView.isUserInteractionEnabled = true
        workoutContainerView.addGestureRecognizer(workoutTapGestureRecognizer)
        
        workoutContainerView.frame = CGRect(x: xMargin, y: y, width: screenWidth - 2 * xMargin, height: 170)
        view.addSubview(workoutContainerView)
        
        y = y + workoutContainerView.frame.height + 10
        
        // Check In Button
        
        checkInButton.frame = CGRect(x: xMargin, y: y, width: view.frame.width - 2 * xMargin, height: 75)
        checkInButton.setImage(UIImage(named: "button_check-in"), for: .normal)
        view.addSubview(checkInButton)
        
        y = y + checkInButton.frame.height + 10
        
        // ADD IN TODAY'S WORKOUT AREA
        
        editScheduleButton.frame = CGRect(x: xMargin, y: y, width: view.frame.width - 2 * xMargin, height: 75)
        editScheduleButton.setImage(UIImage(named: "button_edit-schedule"), for: .normal)
        view.addSubview(editScheduleButton)
        
    }
    
    override func viewWillAppear(_ animated : Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func editScheduleAction() {
        let scheduleEditVC = ScheduleEditorVC()
        UIApplication.shared.keyWindow?.rootViewController?.tabPushViewController(VC: scheduleEditVC, animated: true)
        print("edit schedule button pressed")
    }
    
    func checkInAction() {
        
        print("check in action pressed")
    }
    
    func workoutTapAction() {
        guard let displayRoutine = DMM.getCurrentRoutine() else { return }
        let routineViewerVC = RoutineViewerVC()
        routineViewerVC.routine = displayRoutine
        UIApplication.shared.keyWindow?.rootViewController?.tabPushViewController(VC: routineViewerVC, animated: true)
    }
    
    func getCheckInsForLast(timeFrame: TimeInterval)->[Date]? {
        let validDates = DMM.getCheckInDates()?.filter {
            return ($0.timeIntervalSinceNow > -timeFrame)
        }
        return validDates
    }
    
}

