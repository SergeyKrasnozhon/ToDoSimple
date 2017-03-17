//
//  ItemEditCellsCreator.swift
//  TodoSimple
//
//  Created by Sergey on 3/17/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import UIKit

struct ItemEditCellsCreator {
    private let sourceTableView: UITableView
    init(sourceTableView: UITableView) {
        self.sourceTableView = sourceTableView
    }
    
    func createCell(with todoItem: TodoItemCommon?) -> ItemPriorityCell {
        let cell = self.sourceTableView.dequeueReusableCell(withIdentifier: "priorityCell") as! ItemPriorityCell
        cell.priority = todoItem?.priority ?? 0
        return cell
    }
    
    func createCell(with todoItem: TodoItemCommon?) -> ItemDateCell {
        let cell = self.sourceTableView.dequeueReusableCell(withIdentifier: "executeDateCell") as! ItemDateCell
        cell.date = todoItem?.date ?? Date()
        return cell
    }
    
    func createCell(with todoItem: TodoItemCommon?) -> ItemNameCell {
        let cell = self.sourceTableView.dequeueReusableCell(withIdentifier: "nameCell") as! ItemNameCell
        cell.name = todoItem?.name
        return cell
    }
    
    func createCell(with todoItem: TodoItemCommon?) -> ItemNotesCell {
        let cell = self.sourceTableView.dequeueReusableCell(withIdentifier: "notesCell") as! ItemNotesCell
        cell.notes = todoItem?.notes
        return cell
    }
}
