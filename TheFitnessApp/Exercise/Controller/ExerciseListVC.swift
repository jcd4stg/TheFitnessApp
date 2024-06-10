//
//  ExerciseListVC.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 31/05/2024.
//

import UIKit

final class ExerciseListVC: UIViewController {
    private var safeArea: UILayoutGuide!
    private let tableView = UITableView()
    private let exerciseDispatcher = try? ExerciseDispatcher()
    private var exerciseList = ListExerciseResponse(list: [])
    
    private let workout: WorkoutModel

    init(workout: WorkoutModel) {
        self.workout = workout
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        safeArea = view.layoutMarginsGuide
        view.backgroundColor = .dimmedBlue
        setupNavigation()
        setupTableView()
    }
    
    private func setupNavigation() {
        navigationItem.title = workout.title
        let addButton = UIBarButtonItem(
            title: "Add",
            style: .done,
            target: self,
            action: #selector(addAction)
        )
        addButton.tintColor = .customRed
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = tableView.topAnchor.constraint(equalTo: safeArea.topAnchor)
        let leading = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
        
        tableView.backgroundColor = .dimmedBlue
        tableView.register(ExerciseCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    // MARK: - Logic
    
    private func setupData() {
        guard let dispatcher = exerciseDispatcher else {
            print("\(self): dispatcher was nil")
            return
        }
        
        guard let workoutId = try? workout.requireID() else {
            print("\(self): workout Id was nil")
            return
        }
        
        let request = ListExerciseRequest(workoutId: workoutId)
        exerciseList = dispatcher.list(request: request)
        tableView.reloadData()
    }
    
    // MARK: - Action
    
    @objc private func addAction() {
        guard let workoutId = try? workout.requireID() else {
            print("\(self): workout Id was nil")
            return
        }
        
        let vc = CreateExerciseVC(mode: .create(workoutId))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ExerciseListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseList.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let exerciseCell = cell as? ExerciseCell else {
            return cell
        }
        let model = exerciseList.list[indexPath.row]
        print("..: \(model.kind)")
        exerciseCell.set(model: model)
        return exerciseCell
    }
}

extension ExerciseListVC: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let exercise = exerciseList.list[indexPath.row]

        // Delete
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
            guard let strongSelf = self else { return }
            // delete from the database
            // - dispatcher call
            guard let dispatcher = strongSelf.exerciseDispatcher else {
                print("\(String(describing: self)): dispatcher was nil")
                return
            }
            
            do {
                let request = DeleteExerciseRequest(exerciseId: try exercise.requireID())
                let _ = try dispatcher.delete(request: request)
            } catch {
                completion(false)
                print("Show error model with message: \(error)")
                return
            }
            
            // delete from the datasoure
            // - exerciseList
            guard let index = strongSelf.exerciseList.list.firstIndex(where: { model in
                model.id == exercise.id
            }) else {
                print("Show Error Model: could not find index.")
                strongSelf.setupData()
                return
            }
            
            strongSelf.exerciseList.list.remove(at: index)

            // delete from the tableView
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] action, view, completion in
            let updateExerciseVC = CreateExerciseVC(mode: .edit(exercise))
            self?.navigationController?.pushViewController(updateExerciseVC, animated: true)
        }
        
        editAction.backgroundColor = .dimmedBlue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
}
