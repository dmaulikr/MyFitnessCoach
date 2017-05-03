//
//  DataModelManager.swift
//  MyFitnessCoach
//
//  Created by Andrew Meng on 2017-03-25.
//  Copyright © 2017 Andrew Meng. All rights reserved.
//

import Foundation

let DMM = DataModelManager.sharedManager

final class DataModelManager {
    
    static let sharedManager = DataModelManager()
    
    private var schedule = Schedule()
    private var checkInDates = [Date]()
    private var savedExercises = [Exercise]()
    private var routines = [Routine]()
    private var currentRoutine : Routine?
    
    // sample data
    init() {
        let date1 = Date()
        let date2 = date1.addingTimeInterval(TimeInterval(24 * 3600))
        let date3 = date2.addingTimeInterval(TimeInterval(3 * 24 * 3600))
        checkInDates = [date1, date2, date3]
        
        schedule.scheduledDates = checkInDates
        
        var sampleExercise = Exercise()
        sampleExercise.title = "Sample Exercise 1"
        sampleExercise.description = "Sample Description"
        sampleExercise.creatorName = "System"
        
        var sampleExercise2 = sampleExercise
        sampleExercise2.title = "Sample Exercise 2"
        
        var sampleExercise3 = sampleExercise
        sampleExercise2.title = "Sample Exercise 2"
        
        var sampleExercise4 = sampleExercise
        sampleExercise2.title = "Sample Exercise 2"
        
        var sampleExercise5 = sampleExercise
        sampleExercise2.title = "Sample Exercise 2"
        
        var sampleRoutine = Routine()
        sampleRoutine.title = "Sample Routine"
        sampleRoutine.exercisesIncluded = [sampleExercise, sampleExercise2, sampleExercise3, sampleExercise4, sampleExercise5]
        sampleRoutine.creatorName = "System"
        
        routines = [sampleRoutine]
        savedExercises = [sampleExercise, sampleExercise2]
        
    }
    
    func saveAllData() {
        
    }
    
    @discardableResult func createNewExercise(createdExercise : Exercise)->Exercise {
        var newExercise = Exercise()
        
        newExercise.title = createdExercise.title
        newExercise.description = createdExercise.description
        newExercise.media = createdExercise.media
        newExercise.progressData = createdExercise.progressData
        newExercise.creatorName = createdExercise.creatorName
        
        var newSavedExercises = savedExercises
        newSavedExercises.append(newExercise)
        
        savedExercises = newSavedExercises
        UserDefaults.standard.set(newSavedExercises, forKey: "savedExercises")
        
        return newExercise
    }
    
    func setCurrentRoutine(routine : Routine) {
        self.currentRoutine = routine
    }
    
    func getCurrentRoutine()->Routine? {
        return self.currentRoutine
    }
    
    func getSchedule()->Schedule? {
        return self.schedule
    }
    
    func getCheckInDates()->[Date]? {
        return self.checkInDates
    }
    
    func getExercises()->[Exercise]? {
        return self.savedExercises
    }
    
    func getRoutines()->[Routine]? {
        return self.routines
    }
    
}
