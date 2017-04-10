//
//  DataStructs.swift
//  MyFitnessCoach
//
//  Created by Andrew Meng on 2017-04-09.
//  Copyright © 2017 Andrew Meng. All rights reserved.
//

import Foundation
import UIKit

struct Schedule {
    var type : [String : AnyObject]? =
        ["numberOfDaysWeekly" : 0 as AnyObject,
         "daysOfWeek" : 0 as AnyObject]
    
    var scheduledDates : [Date]?
}

struct MediaData {
    var photo = UIImage(named: "defaultPhoto")
}

struct ProgressDataEntry {
    var sets : Int = 0
    var reps : Int = 0
    var weight : Int = 0
    var dateBenchmarked : Date?
}

struct Exercise {
    var title : String = "New Exercise"
    var description : String = ""
    var media : [MediaData] = []
    var creatorName : String = "System"
    var progressData : [ProgressDataEntry] = []
}

struct Routine {
    var title : String = "New Routine"
    var description : String = ""
    var creatorName : String = "System"
    var muscleGroups : [String] = []
    var exercisesIncluded : [Exercise] = []
}
