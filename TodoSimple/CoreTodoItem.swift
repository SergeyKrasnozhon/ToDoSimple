//
//  CoreTodoItem.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import Foundation
import RealmSwift

class CoreObject: Object {
    open func toDictionary() -> [String: Any] {
        fatalError()
    }
}

class CoreTodoItem: CoreObject {
    struct PropertyKey {
        private init() {}
        static let identifier = "identifier"
        static let name = "name"
        static let notes = "notes"
        static let date = "date"
        static let priority = "priority"
        static let completed = "completed"
    }
    dynamic private(set) var identifier = UUID().uuidString
    dynamic var name = ""
    dynamic var notes = ""
    dynamic var date = Date()
    dynamic var priority: Int = 0
    dynamic var completed = false
    
    override static func primaryKey() -> String? {
        return PropertyKey.identifier
    }
    
    override static func indexedProperties() -> [String] {
        return [PropertyKey.completed, PropertyKey.priority, PropertyKey.date]
    }
    
    override func toDictionary() -> [String: Any] {
        return [PropertyKey.identifier: self.identifier, PropertyKey.name: self.name, PropertyKey.notes: self.notes,
                PropertyKey.date: self.date, PropertyKey.priority: self.priority, PropertyKey.completed: self.completed]
    }
    
    func detached() -> CoreTodoItem {
        return CoreTodoItem(value: self)
    }
}
