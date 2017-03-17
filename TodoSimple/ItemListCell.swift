//
//  ItemListCell.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import UIKit

class ItemListCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet private var completeSwitch: UISwitch!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var priorityLabel: UILabel!

    var statusChanged: ((Bool) -> ())?
    var nameChanged: ((String) -> ())?
    
    var completed: Bool {
        get { return self.completeSwitch.isOn }
        set { self.completeSwitch.setOn(newValue, animated: true) }
    }
    
    func setPriority(_ value: Int) {
        self.priorityLabel.text = String(repeating: "!", count: value)
    }
    
    func setDateString(_ value: String?) {
        self.dateLabel.text = value
    }
    
    func setNameString(_ value: String?) {
        self.nameTextField.text = value
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameTextField.delegate = self
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.nameChanged?(textField.text ?? "")
    }
    
    // MARK: IB Actions
    @IBAction func switchDidChanged(_ sender: UISwitch) {
        self.statusChanged?(self.completed)
    }
}
