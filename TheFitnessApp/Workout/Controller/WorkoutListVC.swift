//
//  ViewController.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 09/05/2024.
//

import UIKit

final class WorkoutListVC: UIViewController {

    private var safeArea: UILayoutGuide!
    private let tableView = UITableView()
    private let workoutDispatcher = try? WorkoutDispatcher()
    
    var workoutList: ListWorkoutResponse = ListWorkoutResponse(list: [])
    
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
        navigationItem.title = "Workout"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customWhite]
        navigationController?.navigationBar.barTintColor = .dimmedBlue
        
        let addButton =  UIBarButtonItem(
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
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none

    }
    
    // MARK: - Logic
    
    private func setupData() {
        guard let dispatcher = workoutDispatcher else {
            print("\(self): dispatcher was nil")
            return
        }
        workoutList = dispatcher.list(request: ListWorkoutRequest())
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func addAction() {
        let vc = CreateWorkoutVC(mode: .create)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension WorkoutListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workout = workoutList.list[indexPath.row]
        let workoutDetailVC = ExerciseListVC(workout: workout)
        navigationController?.pushViewController(workoutDetailVC, animated: true)
    }
    
    // Edit Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let workout = workoutList.list[indexPath.row]
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] action, view, completion in
            let vc = CreateWorkoutVC(mode: .edit(workout))
            self?.navigationController?.pushViewController(vc, animated: true)
            completion(true)
        }
        
        editAction.backgroundColor = .dimmedBlue
        
        // Delete
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
            guard let strongSelf = self else { return }
            // delete from the database
            // - dispatcher call
            guard let dispatcher = strongSelf.workoutDispatcher else {
                print("\(String(describing: self)): dispatcher was nil")
                return
            }
            
            do {
                let request = DeleteWorkoutRequest(id: try workout.requireID())
                let _ = try dispatcher.delete(request: request)
            } catch {
                completion(false)
                print("Show error model with message: \(error)")
                return
            }
            
            // delete from the datasoure
            // - workoutList
            guard let index = strongSelf.workoutList.list.firstIndex(where: { model in
                model.id == workout.id
            }) else {
                print("Show Error Model: could not find index.")
                strongSelf.setupData()
                return
            }
            
            strongSelf.workoutList.list.remove(at: index)

            // delete from the tableView
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
                
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

// MARK: - UITableViewDataSource
extension WorkoutListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutList.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let workoutCell = cell as? WorkoutCell else {
            return cell
        }
        
        let response = workoutList.list[indexPath.row]
        let model = WorkoutModel(title: response.title)
        workoutCell.set(model: model)
        
        return workoutCell
    }
}

