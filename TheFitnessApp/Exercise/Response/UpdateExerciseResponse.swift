//
//  UpdateExerciseResponse.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 09/06/2024.
//

import Foundation

struct UpdateExerciseResponse {
    let id: Int64
    var title: String
    let min: Int
    let sec: Int
    let kind: ExerciseModel.Kind
    
}
