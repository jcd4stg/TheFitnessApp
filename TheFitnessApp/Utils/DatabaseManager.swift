//
//  DatabaseManager.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 23/05/2024.
//

import SQLite
import Foundation

final class DatabaseManager {
    static let `default` = try? DatabaseManager()

    let db: Connection
    
    let workoutRepository: WorkoutRepository
    let exerciseRepository: ExerciseRepository
    
    init() throws {
        guard
            let path = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first 
        else {
            throw DatabaseError.couldNotFindPathToCreateADatabaseFileIn
        }
        
        db = try Connection("\(path)/db.sqlite3")
        print(db.description)
        
        // Dropping all tables
        try WorkoutRepository.dropTable(in: db)
        try ExerciseRepository.dropTable(in: db)
        
        // Creating all Tables
        workoutRepository = try WorkoutRepository(db: db)
        
        // exercise repository
        exerciseRepository = try ExerciseRepository(db: db)
    }
    
}

extension DatabaseManager {
    enum DatabaseError: Error {
        case couldNotFindPathToCreateADatabaseFileIn
    }
}
