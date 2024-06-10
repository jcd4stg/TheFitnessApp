//
//  NewTimeTextFieldDelegate.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 05/06/2024.
//

protocol NewTimeTextFieldDelegate: AnyObject {
    func valueHaveChanged(to min: Int, sec: Int)
}
