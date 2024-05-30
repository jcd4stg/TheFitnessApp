//
//  WorkoutRepository.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 25/05/2024.
//

import SQLite

final class WorkoutRepository {
    private let db: Connection
    private static let tableName = "workout"
    
    static func dropTable(in db: Connection) throws {
        try db.execute("DROP TABLE '\(tableName)'")
    }
    
    init(db: Connection, debug: Bool = false) throws {
        self.db = db
        if debug {
            
        }
        try setup()
    }
    
    // MARK: - Private
    private func setup() throws {
        let workout = Table(WorkoutRepository.tableName)
        let id = Expression<Int64>("id")
        let title = Expression<String>("title")
        
        try db.run(workout.create { table in
            table.column(id, primaryKey: true)
            table.column(title)
        })
        print("Created table: \(WorkoutRepository.self)")
    }
    
    // MARK: - Public
    func insert() {
        
    }
}
