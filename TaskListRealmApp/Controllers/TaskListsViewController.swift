//
//  TaskListsViewController.swift
//  TaskListRealmApp
//
//  Created by Kirill Taraturin on 09.07.2023.
//

import UIKit

final class TaskListsViewController: UIViewController {
    
    // MARK: - Private Properties
    private var segmentedControll = UISegmentedControl()
    private let mainTableView = UITableView()
    private var tasklists: [String] = []
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        segmentedControll = UISegmentedControl(items: ["Date", "A-Z"])
        
        view.addSubview(segmentedControll)
        view.addSubview(mainTableView)
        
        setupNavigationBar()
        setupSegmentedControll()
        setupTableView()
    }
    
    // MARK: - Private Methods
    @objc private func addNewTask() {
        showAlert()
    }
    
    private func setupSegmentedControll() {
        segmentedControll.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControll.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 140
            ),
            
            segmentedControll.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            
            segmentedControll.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            )
        ])
        
        segmentedControll.selectedSegmentIndex = 0
    }
    
    private func setupTableView() {
        mainTableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(
                equalTo: segmentedControll.bottomAnchor,
                constant: 5
            ),
            
            mainTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            
            mainTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            
            mainTableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
    
    private func setupNavigationBar() {
        title = "Task Lists"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    private func showAlert() {
        let alertController = UIAlertController(
            title: "Add new task",
            message: "What do you want to do?",
            preferredStyle: .alert
        )
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            guard let task = alertController.textFields?.first?.text else { return }
            self?.tasklists.append(task)
            let indexPath = IndexPath(row: (self?.tasklists.count ?? 0) - 1, section: 0)
            self?.mainTableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField()
        
        present(alertController, animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension TaskListsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasklists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        
        let task = tasklists[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = task
        
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasklists.remove(at: indexPath.row)
            mainTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
