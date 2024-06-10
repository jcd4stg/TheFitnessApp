//
//  CreateExerciseRequest.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 02/06/2024.
//

import Foundation

struct CreateExerciseRequest: ExerciseValidatable {
    let workoutId: Int64
    var title: String
    var min: Int
    var sec: Int
    var kind: ExerciseModel.Kind
}
