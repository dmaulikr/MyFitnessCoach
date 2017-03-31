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
    
    let dataDic : [String : AnyObject] = [:]
    
}
