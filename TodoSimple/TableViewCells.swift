//
//  TableViewCells.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import UIKit

class ItemNameCell: UITableViewCell {
    @IBOutlet private var nameTextFiled: UITextField!
    var name: String? {
        get { return self.nameTextFiled.text }
        set { self.nameTextFiled.text = newValue }
    }
}

class ItemNotesCell: UITableViewCell {
    @IBOutlet private var notesTextView: UITextView!
    var notes: String? {
        get { return self.notesTextView.text }
        set { self.notesTextView.text = newValue }
    }
}

class ItemDateCell: UITableViewCell {
    @IBOutlet private var datePicker: UIDatePicker!
    var date: Date {
        get { return self.datePicker.date }
        set { self.datePicker.date = newValue }
    }
}

class ItemPriorityCell: UITableViewCell {
    @IBOutlet private var prioritySegmentedControl: UISegmentedControl!
    var priority: Int {
        get { return self.prioritySegmentedControl.selectedSegmentIndex }
        set { self.prioritySegmentedControl.selectedSegmentIndex = newValue }
    }
}
