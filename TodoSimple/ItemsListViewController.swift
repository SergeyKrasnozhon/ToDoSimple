//
//  ItemsListViewController.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import UIKit

class ItemsListViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var completedFilterButton: UIButton!
    private var datasource = TodoItemsDatasource()
    private var keyboardHandler: KeyboardHandler?
    private let cellInfo = CellInfo(identifier: "todoItemCell", height: 60)
    private var needShowCompleted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "ts_needShowCompleted")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "ts_needShowCompleted")
            UserDefaults.standard.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateCompletedButton()
        self.setupDatasource()
        self.keyboardHandler = KeyboardHandler(rootView: self.view) { [weak self] in
            let additionalOffset: CGFloat = ($0 == 0) ? 0 : 2
            let offset = ($0 + additionalOffset)
            self?.tableView.contentOffset.y += offset
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardHandler?.registerNotifications()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.keyboardHandler?.unregisterNotifications()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.view.ts_currentFirstResponder()?.resignFirstResponder()
    }
    
    // MARK: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.datasource.filterString = searchText
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.itemsCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellInfo.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellInfo.identifier, for: indexPath)
            as! ItemListCell
        if let item: TodoItemAutoWrite = self.datasource.item(at: indexPath.row) {
            self.prepare(cell: cell, with: item, animated: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item: TodoItemInmemory = self.datasource.item(at: indexPath.row) {
                DeleteTodoItemAction().execute(with: item)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let item: TodoItemInmemory = self.datasource.item(at: indexPath.row) {
            self.presentEdit(item: item)
        }
    }
    
    // MARK: IB actions
    @IBAction func addItemTapped(_ sender: UIButton) {
        self.presentEdit(item: self.datasource.templateItem())
    }
    
    @IBAction func applyCompletedTapped(_ sender: UIButton) {
        self.needShowCompleted = !self.needShowCompleted
        self.datasource.needUseCompleted = self.needShowCompleted
        self.updateCompletedButton()
    }
    
    // MARK: Service
    private func setupDatasource() {
        self.datasource.needUseCompleted = self.needShowCompleted
        self.datasource.didUpdate = { [weak self] in
            self?.tableView.reloadSections([0], with: .automatic)
        }
        self.datasource.didChange = self.createUpdatingBlock()
    }
    
    private func createUpdatingBlock() -> (TodoItemsDatasourceChanges) -> Void {
        return { [weak self] (changes: TodoItemsDatasourceChanges) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.beginUpdates()
            strongSelf.tableView.insertRows(at: changes.insertions.map { IndexPath(row: $0, section: 0) },
                                 with: .automatic)
            strongSelf.tableView.deleteRows(at: changes.deletions.map { IndexPath(row: $0, section: 0) },
                                 with: .automatic)
            changes.updatedItems.forEach {
                let indexPath = IndexPath(row: $0.index, section: 0)
                if let cell = strongSelf.tableView.cellForRow(at: indexPath) as? ItemListCell {
                    strongSelf.prepare(cell: cell, with: $0.item, animated: true)
                }
            }
            strongSelf.tableView.endUpdates()
        }
    }
    
    private func updateCompletedButton() {
        let title = self.needShowCompleted ? "Hide Completed" : "Show Completed"
        self.completedFilterButton.setTitle(title, for: .normal)
    }
    
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, U HH:mm"
        return formatter.string(from: date)
    }
    
    private func prepare(cell: ItemListCell, with item: TodoItemAutoWrite, animated: Bool) {
        cell.setCompleted(item.completed, animated: animated)
        cell.setNameString(item.name)
        cell.setDateString(self.dateString(from: item.date))
        cell.setPriority(item.priority)

        var item = item
        cell.statusChanged = { item.completed = $0 }
        cell.nameChanged = { item.name = $0 }
    }
    
    private func presentEdit(item: TodoItemInmemory) {
        self.performSegue(withIdentifier: "showItemEditVC", sender: self) { (segue) in
            guard let viewController = segue.destination as? ItemEditViewController else {
                Logger().log(message: "Wrong viewController type for: \(segue.identifier)")
                fatalError()
            }
            viewController.todoItem = item
        }
    }
}

