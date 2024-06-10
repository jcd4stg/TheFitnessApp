//
//  UpdateExerciseRequest.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 09/06/2024.
//

import Foundation

struct UpdateExerciseRequest: ExerciseValidatable {
    let id: Int64
    var title: String
    var min: Int
    var sec: Int
    var kind: ExerciseModel.Kind
    
}

 
