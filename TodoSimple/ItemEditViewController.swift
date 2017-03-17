//
//  ItemEditViewController.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import UIKit

class ItemEditViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    var todoItem: TodoItemInmemory?
    @IBOutlet private var tableView: UITableView!
    private var keyboardHandler: KeyboardHandler?
    private var name: () -> (String) = {""}
    private var notes: () -> (String) = {""}
    private var date: () -> (Date) = {Date()}
    private var priority: () -> (Int) = {0}
    
    lazy var sections: [[(cell: UITableViewCell, height: CGFloat)]] = {
        let nameCell = self.createCell() as ItemNameCell
        let executeDateCell = self.createCell() as ItemDateCell
        let priorityCell = self.createCell() as ItemPriorityCell
        let notesCell = self.createCell() as ItemNotesCell
        return [
            [(nameCell, 50)], [(priorityCell, 200)], [(priorityCell, 50), (notesCell, 150)]
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboardHandler = KeyboardHandler(rootView: self.view) { [weak self] in
            let additionalOffset: CGFloat = ($0 == 0) ? 0 : 20
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
    
    // MARK: IB Actions
    @IBAction func doneTapped(_ sender: UIButton) {
        self.prepareResultItem()
        self.todoItem?.persist()
    }
    
    // MARK: Service
    private func prepareResultItem() {
        self.todoItem?.name = self.name()
        self.todoItem?.notes = self.notes()
        self.todoItem?.date = self.date()
        self.todoItem?.priority = self.priority()
    }

    // MARK: Cells creating
    private func createCell() -> ItemPriorityCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "priorityCell") as! ItemPriorityCell
        cell.priority = self.todoItem?.priority ?? 0
        self.priority = { cell.priority }
        return cell
    }
    
    private func createCell() -> ItemDateCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "executeDateCell") as! ItemDateCell
        cell.date = self.todoItem?.date ?? Date()
        self.date = { cell.date }
        return cell
    }
    
    private func createCell() -> ItemNameCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "nameCell") as! ItemNameCell
        cell.name = self.todoItem?.name
        self.name = { cell.name ?? "" }
        return cell
    }
    
    private func createCell() -> ItemNotesCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "notesCell") as! ItemNotesCell
        cell.notes = self.todoItem?.notes
        self.notes = { cell.notes ?? "" }
        return cell
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.sections[indexPath.section]
        return section[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.section]
        let cell = section[indexPath.row].cell
        return cell
    }
}
