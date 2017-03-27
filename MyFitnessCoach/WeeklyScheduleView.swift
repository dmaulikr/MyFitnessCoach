//
//  WeeklyScheduleView.swift
//  MyFitnessCoach
//
//  Created by Andrew Meng on 2017-03-26.
//  Copyright © 2017 Andrew Meng. All rights reserved.
//

import UIKit

protocol WeeklyScheduleViewDelegate {
    
}

enum checkInStatus {
    case checkedIn
    case missed
    case undetermined
    case unscheduled
}

class WeeklyScheduleView : UIView {
    
    var schedule : [String : AnyObject]?
    var checkInDates : [NSDate]?
    var delegate : WeeklyScheduleViewDelegate?
    
    private var statusByDay : [String : checkInStatus] = [:]
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

class WeekdayStatusView : UIView {
    
    var dayName : String?
    var checkInStatus : checkInStatus?
    var linkedRoutine : [String : AnyObject]?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
