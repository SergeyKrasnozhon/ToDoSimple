//
//  ItemEditViewController.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import UIKit

class ItemEditViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    private typealias CellsConfigureBlock = (ItemNameCell, ItemDateCell, ItemPriorityCell, ItemNotesCell) -> Void
    var todoItem: TodoItemInmemory?
    @IBOutlet private var tableView: UITableView!
    private var keyboardHandler: KeyboardHandler?
    private var name: () -> (String) = {""}
    private var notes: () -> (String) = {""}
    private var date: () -> (Date) = {Date()}
    private var priority: () -> (Int) = {0}
    
    private var sections = [[(cell: UITableViewCell, height: CGFloat)]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sections = self.createSections(withConfigure: self.createCellsConficurator())
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
        self.dismiss()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss()
    }
    
    // MARK: Service
    private func dismiss() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func createCellsConficurator() -> CellsConfigureBlock {
        return {
            let (nameCell, dateCell, priorityCell, notesCell) = $0
            self.name = { nameCell.name ?? "" }
            self.notes = { notesCell.notes ?? "" }
            self.date = { dateCell.date }
            self.priority = { priorityCell.priority }
        }
    }
    
    private func createSections(
        withConfigure configure: CellsConfigureBlock) -> [[(cell: UITableViewCell, height: CGFloat)]] {
        let cellsCreator = ItemEditCellsCreator(sourceTableView: self.tableView)
        
        let nameCell = cellsCreator.createCell(with: self.todoItem) as ItemNameCell
        let executeDateCell = cellsCreator.createCell(with: self.todoItem) as ItemDateCell
        let priorityCell = cellsCreator.createCell(with: self.todoItem) as ItemPriorityCell
        let notesCell = cellsCreator.createCell(with: self.todoItem) as ItemNotesCell
        configure(nameCell, executeDateCell, priorityCell, notesCell)
        return [
            [(nameCell, 50)], [(executeDateCell, 200)], [(priorityCell, 50), (notesCell, 150)]
        ]
    }
    
    private func prepareResultItem() {
        self.todoItem?.name = self.name()
        self.todoItem?.notes = self.notes()
        self.todoItem?.date = self.date()
        self.todoItem?.priority = self.priority()
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
