//
//  AlertManager.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 10/06/2024.
//

import UIKit

struct AlertManager {
    
    static func confirmError(on vc: UIViewController, message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true)
    }
}
