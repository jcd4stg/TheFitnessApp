//
//  CreateExerciseVC.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 03/06/2024.
//

import UIKit

final class CreateExerciseVC: UIViewController {
    private var safeArea: UILayoutGuide!
    
    private var createExerciseRequest: CreateExerciseRequest?
    private var updateExerciseRequest: UpdateExerciseRequest?
    
    private let nameTextField = NewTextField(title: "Name")
    private let timeTextField = NewTimeTextField()
    
    private let exercisePauseLabel = UILabel()
    private let exercisePauseControl = UISegmentedControl(items: ["Exercise", "Pause"])
    
    private let saveCancelButtons = SaveCancelButtons()
    private let exerciseDispatcher = try? ExerciseDispatcher()

    private var mode: Mode
    private var exerciseModel: ExerciseModel?
    
    enum Mode {
        case create(Int64)
        case edit(ExerciseModel)
    }
    
    init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
        
        switch mode {
        case .create(let workoutId):
            self.createExerciseRequest = CreateExerciseRequest(
                workoutId: workoutId,
                title: "",
                min: 0,
                sec: 0,
                kind: .exercise
            )

        case .edit(let exerciseModel):
            setupData(with: exerciseModel)
        }
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
        setupTimeTextField()
        setupExercisePauseLabel()
        setupExercisePauseControl()
        
        setupSaveCancelButtons()
    }

    private func setupNavigation() {
        
        switch mode {
        case .create:
            navigationItem.title = "Create"
        case .edit:
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
    
    private func setupTimeTextField() {
        view.addSubview(timeTextField)
        timeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let top = timeTextField.topAnchor.constraint(equalTo:  nameTextField.bottomAnchor, constant: 30)
        let leading = timeTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        let trailing = timeTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        NSLayoutConstraint.activate([top, leading, trailing])
        
        timeTextField.delegate = self
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

    private func setupExercisePauseLabel() {
        view.addSubview(exercisePauseLabel)
        exercisePauseLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = exercisePauseLabel.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 30 )
        let leading = exercisePauseLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        NSLayoutConstraint.activate([top, leading])
        
        exercisePauseLabel.text = "Type"
        exercisePauseLabel.textColor = .customWhite
        exercisePauseLabel.font = .boldSystemFont(ofSize: 24)
    }
    
    private func setupExercisePauseControl() {
        view.addSubview(exercisePauseControl)
        exercisePauseControl.translatesAutoresizingMaskIntoConstraints = false
        
        let top = exercisePauseControl.topAnchor.constraint(equalTo: exercisePauseLabel.bottomAnchor, constant: 15)
        let leading = exercisePauseControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        let trailing = exercisePauseControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        NSLayoutConstraint.activate([top, leading, trailing])
        
        exercisePauseControl.tintColor = .customWhite
        exercisePauseControl.addTarget(self, action: #selector(exercisePauseAction(_:)), for: .valueChanged)
        
        switch mode {
        case .create(_):
            exercisePauseControl.selectedSegmentIndex = SegmentedControlItem.exercise.rawValue
        default: return
        }
    }
    
    // MARK: - Action
    
    @objc private func exercisePauseAction(_ control: UISegmentedControl) {
        
        guard
            let title = control.titleForSegment(at: control.selectedSegmentIndex),
            let controlItem = ExerciseModel.Kind(rawValue: title.lowercased())
        else {
            print("❌ \(self): couldn't instantiate \(ExerciseModel.Kind.self)")
            return
        }
        
        switch mode {
        case .create(_):
            createExerciseRequest?.kind = controlItem
        case .edit(_):
            updateExerciseRequest?.kind = controlItem
        }
        
        switch controlItem {
        case .exercise:
            enableNameField()
        case .pause:
            disableNameField()
        }
    }
    
    // MARK: - Logic
    
    private func setupData(with model: ExerciseModel) {
        switch model.kind {
        case .exercise: nameTextField.set(name: model.title)
        case .pause: nameTextField.disable()
        }
        
        let timeModel = NewTimeTextField.Model(min: model.min, sec: model.sec)
        timeTextField.set(with: timeModel)
        
        guard let segmentIndex = SegmentedControlItem(kind: model.kind)?.rawValue else {
            print("❌ Could not populate Exercise/Pause Segmented Control based on \(model.kind)")
            return
        }
        exercisePauseControl.selectedSegmentIndex = segmentIndex
        
        guard let exerciseId = model.id else {
            print("❌ exercise id was nil in model \(model)")
            return
        }
        
        self.updateExerciseRequest = UpdateExerciseRequest(
            id: exerciseId,
            title: model.title,
            min: model.min,
            sec: model.sec,
            kind: model.kind
        )
    }
    
    private func disableNameField() {
        nameTextField.disable()
        
        updateExerciseRequest?.title = ""
        createExerciseRequest?.title = ""
    }
    
    private func enableNameField() {
        nameTextField.enable()
    }
    
    private func createExercise() {
        // TODO: VALIDATE createExerciseRequest before persisting
        
        guard let request = createExerciseRequest else {
            print("\(self): createExerciseRequest was nil ")
            return
        }
        
        switch request.isValid() {
        case .success():
            ()
        case .failure(let error):
            AlertManager.confirmError(on: self, message: error.description)
            return
        }
        
        guard let dispatcher = exerciseDispatcher else {
            print("\(self): workoutDispatcher was nil")
            return
        }
        
        guard ((try? dispatcher.create(request: request)) != nil) else {
            print("Show model saying: Could not save workout, please reach out to Developer")
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func updateExercise() {
        
        guard let request = updateExerciseRequest else {
            print("\(self): updateExerciseRequest was nil ")
            return
        }
        
        switch request.isValid() {
        case .success():
            ()
        case .failure(let error):
            AlertManager.confirmError(on: self, message: error.description)
            return
        }
        
        guard let dispatcher = exerciseDispatcher else {
            print("\(self): workoutDispatcher was nil")
            return
        }
       
        guard ((try? dispatcher.update(request: request)) != nil) else {
            print("Show model saying: Could not save workout, please reach out to Developer")
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension CreateExerciseVC: NewTimeTextFieldDelegate {
    func valueHaveChanged(to min: Int, sec: Int) {
        
        switch mode {
        case .create(_):
            createExerciseRequest?.min = min
            createExerciseRequest?.sec = sec
        case .edit(_):
            updateExerciseRequest?.min = min
            updateExerciseRequest?.sec = sec       
        }
    }
}

// MARK: - SaveCancelButtonsDelegate
extension CreateExerciseVC: SaveCancelButtonsDelegate {
    func onCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    func onSave() {
        
        switch mode {
        case .create:
            createExercise()
        case .edit:
            updateExercise()
        }
    }
}

extension CreateExerciseVC: NewTextFieldDelegate {
    func valueDidChange(to text: String) {
        switch mode {
        case .create(_):
            createExerciseRequest?.title = text
        case .edit(_):
            updateExerciseRequest?.title = text
        }
    }
}

extension CreateExerciseVC {
    enum SegmentedControlItem: Int {
        case exercise
        case pause
        
        var description: String {
            switch self {
            case .exercise:
                return "exercise"
            case .pause:
                return "pause"
            }
        }
        
        init?(kind: ExerciseModel.Kind) {
            switch kind {
            case .exercise:
                self.init(rawValue: 0)
            case .pause:
                self.init(rawValue: 1)
            }
        }
    }
}


