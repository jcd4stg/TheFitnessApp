//
//  ExerciseValidatable.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 10/06/2024.
//

import Foundation

protocol ExerciseValidatable {
    var title: String { get set }
    var min: Int { get set }
    var sec: Int { get set }
    var kind: ExerciseModel.Kind { get set }

}

extension ExerciseValidatable {
    
    func isValid() -> Result<Void, ExerciseValidationError> {
        
        if title.isEmpty && kind == .exercise {
            return .failure(ExerciseValidationError.titleIsEmpty)
        }
        
        if min == 0 && sec == 0 {
            return .failure(ExerciseValidationError.timeCannotBeZero)
        }
        
        return .success(())
    }
}

enum ExerciseValidationError: String, Error {
    case titleIsEmpty
    case timeCannotBeZero
    
    var description: String {
        return self.rawValue
    }
}
