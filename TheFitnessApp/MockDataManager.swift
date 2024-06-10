//
//  MockDataManager.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 25/05/2024.
//

import Foundation

struct MockDataManager {
    static func createWorkout(amount: Int = 7) {
        guard let dbManager = DatabaseManager.default else {
            return
        }
        
        for number in 1...amount {
            let request = CreateWorkoutRequest(title: "\(number) - Martin Lasek")
            guard (try? dbManager.workoutRepository.insert(request: request)) != nil else {
                print("couldn't insert into workout table")
                return
            }
        }
        
    }
}
