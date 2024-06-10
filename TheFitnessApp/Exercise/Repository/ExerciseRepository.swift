//
//  ExerciseRepository.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 01/06/2024.
//

import SQLite

final class ExerciseRepository {
    private let db: Connection
    static let table = Table(ExerciseModel.tableName)
    
    // Columns
    static let id = Expression<Int64>("id")
    static let workoutId = Expression<Int64>("workout_id")
    static let title = Expression<String>("title")
    static let min = Expression<Int>("min")
    static let sec = Expression<Int>("sec")
    static let kind = Expression<String>("kind")

    static func dropTable(in db: Connection) throws {
        try db.execute("DROP TABLE IF EXISTS '\(ExerciseModel.tableName)'")
        print("Dropped Table: \(ExerciseRepository.self)")
    }
    
    init(db: Connection) throws {
        self.db = db
        try setup()
    }
    
    // MARK: - Private
    
    private func setup() throws {
        try db.run(Self.table.create(ifNotExists: true) { table in
            table.column(Self.id, primaryKey: true)
            table.column(
                Self.workoutId,
                references: WorkoutRepository.table,
                WorkoutRepository.id
            )
            table.column(Self.title)
            table.column(Self.min)
            table.column(Self.sec)
            table.column(Self.kind)
        })
        print("Created table (If I didn't exist: \(ExerciseModel.tableName)")
    }
    
    // MARK: - Public
    
    func insert(request: CreateExerciseRequest) throws -> ExerciseModel {
        let insert = Self.table.insert(
            Self.workoutId <- request.workoutId,
            Self.title <- request.title,
            Self.min <- request.min,
            Self.sec <- request.sec,
            Self.kind <- request.kind.rawValue
        )
        let rowId = try db.run(insert)
            
        return ExerciseModel(
            id: rowId,
            workoutId: request.workoutId,
            title: request.title,
            min: request.min,
            sec: request.sec,
            kind: request.kind
        )
    }
    
    func list(request: ListExerciseRequest) -> [ExerciseModel] {
        let query = Self.table.filter(Self.workoutId == request.workoutId)
        do {
            return try db.prepare(query).map({ exercise in
                guard let kind = ExerciseModel.Kind(rawValue: exercise[Self.kind]) else {
                    throw ExerciseModel.ExerciseError.unsupportedKind
                }
                return ExerciseModel(
                    id: exercise[Self.id],
                    workoutId: exercise[Self.workoutId],
                    title: exercise[Self.title],
                    min: exercise[Self.min],
                    sec: exercise[Self.sec],
                    kind: kind
                )
            })
        } catch {
            print("\(self): Could not get list of \(ExerciseRepository.self) from the database.")
            return []
        }
    }
    
    func delete(request: DeleteExerciseRequest) throws {
        let exercise = Self.table.filter(Self.id == request.exerciseId)
        try db.run(exercise.delete())        
    }
    
    func update(request: UpdateExerciseRequest) throws  {
        let exercise = Self.table.filter(Self.id == request.id)
        try db.run(exercise.update(
            Self.title <- request.title,
            Self.min <- request.min,
            Self.sec <- request.sec,
            Self.kind <- request.kind.rawValue
        ))
    }
}

extension ExerciseRepository {
    enum ExerciseRepositoryError: Error {
        case couldNotGetDatabaseManagerInstance
        case couldNotGetExerciseRepositoryInstance
    }
}
