//
//  ExerciseDispatcher.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 02/06/2024.
//

import UIKit

final class ExerciseDispatcher {
    private let exerciseRepository: ExerciseRepository
    
    init() throws {
        guard let databaseManager = DatabaseManager.default else {
            throw DatabaseManager.DatabaseError.couldNotFindPathToCreateADatabaseFileIn
        }

        guard let exerciseRepository = try? ExerciseRepository(db: databaseManager.db) else {
            throw ExerciseRepository.ExerciseRepositoryError.couldNotGetExerciseRepositoryInstance
        }
        self.exerciseRepository = exerciseRepository
    }
    
    // Create a exercise
    func create(request: CreateExerciseRequest) throws -> CreateExerciseResponse {
        let persistedModel = try exerciseRepository.insert(request: request)
        return CreateExerciseResponse(exercise: persistedModel)
    }
    
    // Return list of all exercises
    func list(request: ListExerciseRequest) -> ListExerciseResponse {
        let list = exerciseRepository.list(request: request)
        return ListExerciseResponse(list: list)
    }
    
    // Delete an exercise
    func delete(request: DeleteExerciseRequest) throws -> DeleteExerciseResponse {
        try exerciseRepository.delete(request: request)
        return DeleteExerciseResponse()
    }
    
    func update(request: UpdateExerciseRequest) throws  {
        return try exerciseRepository.update(request: request)
    }
}

