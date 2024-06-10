//
//  CreateWorkoutVC.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 27/05/2024.
//

import UIKit

final class CreateWorkoutVC: UIViewController {
    private var safeArea: UILayoutGuide!
    
    private let nameTextField = NewTextField(title: "Name")
    
    private let saveCancelButtons = SaveCancelButtons()
    private let workoutDispatcher = try? WorkoutDispatcher()
    
    private var mode: Mode
    private var workoutModel: WorkoutModel?
    
    private var createWorkoutRequest: CreateWorkoutRequest?
    private var updateWorkoutRequest: UpdateWorkoutRequest?
    
    enum Mode {
        case create
        case edit(WorkoutModel)
    }
    
    init(mode: Mode) {
        self.mode = mode
        switch mode {
        case .create:
            ()
        case .edit(let workoutModel):
            self.workoutModel = workoutModel
            nameTextField.set(name: workoutModel.title)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .dimmedBlue
        safeArea = view.layoutMarginsGuide
        
        setupNavigation()
        setupNameTextField()
        setupSaveCancelButtons()
    }
    
    private func setupNavigation() {
        switch mode {
        case .create:
            navigationItem.title = "Create"
        case .edit(_):
            navigationItem.title = "Edit"
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customWhite]
    }
    
    private func setupNameTextField() {
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let top = nameTextField.topAnchor.constraint(equalTo: safeArea.topAnchor)
        let leading = nameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        let trailing = nameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        NSLayoutConstraint.activate([top, leading, trailing])
        
        nameTextField.delegate = self
    }
    
    private func setupSaveCancelButtons() {
        view.addSubview(saveCancelButtons)
        saveCancelButtons.translatesAutoresizingMaskIntoConstraints = false
        
        let bottom = saveCancelButtons.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        let leading = saveCancelButtons.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        let trailing = saveCancelButtons.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        NSLayoutConstraint.activate([bottom, leading, trailing])
        
        saveCancelButtons.delegate = self
    }
    
    // MARK: - Logic
    
    private func createWorkout() {
        
        guard 
            let createRequest = createWorkoutRequest,
            let dispatcher = workoutDispatcher
        else {
            print("\(self): workoutDispatcher was nil")
            return
        }
        
        guard ((try? dispatcher.create(request: createRequest)) != nil) else {
            print("Show model saying: Could not save workout, please reach out to Developer")
            return
        }
    }
    
    private func updateWorkout() {
        guard
            let updateRequest = updateWorkoutRequest,
            let dispatcher = workoutDispatcher
        else {
            print("\(self): workoutModel or workoutDispatcher is nil")
            return
        }
                
        guard ((try? dispatcher.update(request: updateRequest)) != nil) else {
            print("Show model saying: Could not save workout, please reach out to Developer")
            return
        }
    }
}

// MARK: - UITextFieldDelegate
extension CreateWorkoutVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

// MARK: - SaveCancelButtonsDelegate
extension CreateWorkoutVC: SaveCancelButtonsDelegate {
    func onCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    func onSave() {
        switch mode {
        case .create:
            createWorkout()
        case .edit:
            updateWorkout()
        }
        navigationController?.popViewController(animated: true)
    }
}

extension CreateWorkoutVC: NewTextFieldDelegate {
    func valueDidChange(to text: String) {
        
        switch mode {
        case .create:
            createWorkoutRequest = CreateWorkoutRequest(title: text)
        case .edit:
            guard let model = workoutModel,
                  let id = model.id
            else {
                print("\(self): workoutModel or workoutDispatcher is nil")
                return
            }
            updateWorkoutRequest = UpdateWorkoutRequest(id: id, newTitle: text)
        }
    }
}

