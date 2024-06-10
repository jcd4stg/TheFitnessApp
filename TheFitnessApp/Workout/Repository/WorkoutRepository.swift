//
//  WorkoutRepository.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 25/05/2024.
//

import SQLite
import Foundation

final class WorkoutRepository {
    private let db: Connection
    static let table = Table(WorkoutModel.tableName)
    
    // Columns
    static let id = Expression<Int64>("id")
    static let title = Expression<String>("title")
    
    static func dropTable(in db: Connection) throws {
        try db.execute("DROP TABLE IF EXISTS '\(WorkoutModel.tableName)'")
        print("Dropped Table: \(WorkoutRepository.self)")
    }
    
    init(db: Connection) throws {
        self.db = db
        try setup()
    }

    // MARK: - Private
    
    private func setup() throws {
        try db.run(WorkoutRepository.table.create(ifNotExists: true) { table in
            table.column(WorkoutRepository.id, primaryKey: true)
            table.column(WorkoutRepository.title)
        })
        print("Created table (If I didn't exist: \(WorkoutModel.tableName)")
    }
    
    // MARK: - Public
    func insert(request: CreateWorkoutRequest) throws -> WorkoutModel {
        let insert = Self.table.insert(Self.title <- request.title)
        let rowId = try db.run(insert)
        
        return WorkoutModel(id: rowId, title: request.title)
    }
    
    func list() -> [WorkoutModel] {
        do {
            return try db.prepare(Self.table).map({ workout in
                return WorkoutModel(id: workout[Self.id], title: workout[Self.title])
            })
        } catch {
            print("\(self): Could not get list of workout from the database.")
            return []
        }
    }
    
    func update(request: UpdateWorkoutRequest) throws -> WorkoutModel {
        let workout = Self.table.filter(Self.id == request.id)
        try db.run(workout.update(Self.title <- request.newTitle))
        return WorkoutModel(id: request.id, title: request.newTitle)
    }
    
    func delete(request: DeleteWorkoutRequest) throws {
        let workout = Self.table.filter(Self.id == request.id)
        try db.run(workout.delete())
    }
}
