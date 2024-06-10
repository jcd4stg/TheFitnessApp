//
//  WorkoutDispatcher.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 26/05/2024.
//

import Foundation

struct WorkoutDispatcher {
    private let workoutRepository: WorkoutRepository
    
    init() throws {
        guard let databaseManager = DatabaseManager.default else {
            throw WorkoutDispatcherError.couldNotGetDatabaseManagerInstance
        }
        
        guard let workoutRepository = try? WorkoutRepository(db: databaseManager.db) else {
            throw WorkoutDispatcherError.couldNotGetWorkoutRepositoryInstance
        }
        self.workoutRepository = workoutRepository
    }
    
    // Create a workout
    func create(request: CreateWorkoutRequest) throws -> CreateWorkoutResponse {
        let persistedModel = try workoutRepository.insert(request: request)
        
        return CreateWorkoutResponse(workout: persistedModel)
    }
    
    // Return list of all workouts
    func list(request: ListWorkoutRequest) -> ListWorkoutResponse {
        let list = workoutRepository.list()
        return ListWorkoutResponse(list: list)
    }
    
    // Update a workout based on it's id
    func update(request: UpdateWorkoutRequest) throws -> UpdateWorkoutResponse {
        let persistedModel = try workoutRepository.update(request: request)
        return UpdateWorkoutResponse(title: persistedModel.title)
    }
    
    // Delete a workout based on its' id
    func delete(request: DeleteWorkoutRequest) throws -> DeleteWorkoutResponse {
        try workoutRepository.delete(request: request)
        return DeleteWorkoutResponse()
    }
}

extension WorkoutDispatcher {
    enum WorkoutDispatcherError: Error {
        case couldNotGetDatabaseManagerInstance
        case couldNotGetWorkoutRepositoryInstance
    }
}
