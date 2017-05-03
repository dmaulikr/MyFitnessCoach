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
    
    var schedule : Schedule? {
        didSet {
            guard let allScheduledDates = schedule?.scheduledDates else { return }
            scheduledDatesThisWeek = getDatesForThisWeek(dates: allScheduledDates)
        }
    }
    
    var delegate : WeeklyScheduleViewDelegate?
    var checkedInDates : [Date]? {
        didSet {
            guard checkedInDates != nil else { return }
            checkedInDates = getDatesForThisWeek(dates: checkedInDates!)
            refreshViewStatuses()
        }
    }
    
    private var scheduledDatesThisWeek : [Date]?
    private var dayStatusViews : [WeekdayStatusView] = []
    
    private lazy var expandButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(WeeklyScheduleView.expandCalendar), for: .touchUpInside)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let singleViewWidth : CGFloat = screenWidth / 8
        let weekdayMapping : [String] = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
        
        // The date of the sunday
        let weekStartDate : Date = {
            let currentDate = Date()
            let currentDayOfWeek = currentDate.dayNumberOfWeek()
            return Date(timeInterval: TimeInterval(((1 - currentDayOfWeek!) * 24 * 3600)), since: currentDate.startOfDay)
        }()
        
        var dateForCurrentStatusView = weekStartDate
        
        for i in 0...6 {
            dayStatusViews.append(WeekdayStatusView())
            dayStatusViews[i].frame = CGRect(x: CGFloat(i) * singleViewWidth, y: 0, width: singleViewWidth, height: screenHeight / 9)
            dayStatusViews[i].dayName = weekdayMapping[i]
            dayStatusViews[i].date = dateForCurrentStatusView
            dayStatusViews[i].dayCheckInStatus = calculateCheckInStatus(dateToCheck: dateForCurrentStatusView)
            
            dayStatusViews[i].linkedRoutine = DMM.routines[0] // placeholder
            
            dateForCurrentStatusView = Date(timeInterval: TimeInterval(24 * 3600), since: dateForCurrentStatusView)
            addSubview(dayStatusViews[i])
        }
        
        /*expandButton.frame = CGRect(x: (dayStatusViews.last?.frame.maxX)!, y: (dayStatusViews.last?.frame.minY)!, width: singleViewWidth, height: screenHeight / 9)
        addSubview(expandButton)*/
    }
    
    func refreshViewStatuses() {
        for view in dayStatusViews {
            view.refresh()
        }
    }
    
    func expandCalendar() {
        print("calendar expanded")
    }
    
    //MARK: Processing Functions
    
    func getDatesForThisWeek(dates: [Date])->[Date] {
        let currentDate = Date()
        let dayOfWeek = currentDate.dayNumberOfWeek()
        let validTimeFrameBehind = (dayOfWeek! - 1) * (24 * 3600)
        let validTimeFrameAhead = (7 - dayOfWeek!) * (24 * 3600)
        
        return dates.filter {
            return (currentDate.startOfDay.timeIntervalSince($0) <= TimeInterval(validTimeFrameBehind)) && ($0.startOfDay.timeIntervalSinceNow <= TimeInterval(validTimeFrameAhead))
        }
    }
    
    func calculateCheckInStatus(dateToCheck: Date)->checkInStatus? {
        let timeDifference = dateToCheck.timeIntervalSinceNow
        guard let scheduledDates = scheduledDatesThisWeek else { return .unscheduled }
        
        if scheduledDates.contains(where: { $0.startOfDay == dateToCheck.startOfDay }) {
            if timeDifference > 0 {
                return .undetermined
            } else {
                guard checkedInDates != nil else { return .missed }
                if checkedInDates!.contains(where: { $0.startOfDay == dateToCheck.startOfDay }) {
                    return .checkedIn
                } else {
                    return .missed
                }
            }
        } else {
            return .unscheduled
        }
    }
    
}

class WeekdayStatusView : UIView {
    
    var dayName : String?
    var dayCheckInStatus : checkInStatus?
    var date : Date?
    var linkedRoutine : Routine?
    
    private lazy var dayLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: standardFont, size: 12)
        return label
    }()
    private var calendarDayImage : UIImageView = UIImageView(image: UIImage(named: "calendarDayTemplate"))
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calendarDayImage.frame = CGRect(x: 0, y: 0, width: (screenWidth - 40) / 8, height: screenHeight / 9)
        if dayName != nil {
            dayLabel.text = dayName!
        }
        dayLabel.frame = CGRect(x: 5, y: 5, width: calendarDayImage.frame.width - 10, height: calendarDayImage.frame.height / 5)
        calendarDayImage.addSubview(dayLabel)
        addSubview(calendarDayImage)
        
        let calendarTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WeekdayStatusView.tapAction))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(calendarTapGestureRecognizer)
        
        refresh()
    }
    
    func tapAction(gestureRecognizer: UITapGestureRecognizer) {
        // to open the workout routine linked
        print("Tapped")
        if linkedRoutine != nil {
            let routineViewerVC = RoutineViewerVC()
            routineViewerVC.routine = linkedRoutine!
            
            UIApplication.shared.keyWindow?.rootViewController?.tabPushViewController(VC: routineViewerVC, animated: true)
        }
    }
    
    func refresh() {
        let fillInBox = UIView(frame: CGRect(x: 2, y: dayLabel.frame.height + 10, width : (screenWidth - 44) / 8 - 4, height : calendarDayImage.frame.height - dayLabel.frame.height - 14))
        switch dayCheckInStatus! {
        case .checkedIn:
            fillInBox.backgroundColor = UIColor.green
        case .missed:
            fillInBox.backgroundColor =  UIColor.red
        case .undetermined:
            fillInBox.backgroundColor = UIColor.yellow
        default:
            fillInBox.backgroundColor = UIColor.white
        }
        calendarDayImage.addSubview(fillInBox)
    }
    
    // MARK: Processing Functions
    
    deinit {
        print("WeeklyScheduleView deinit")
    }

}

extension Date {
    
    func dayOfTheWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self)
    }
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
}
