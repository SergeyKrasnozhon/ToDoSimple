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
    dynamic private(set) var identifier = UUID().uuidString
    dynamic var name = ""
    dynamic var notes = ""
    dynamic var date = Date()
    dynamic var priority: Int = 0
    dynamic var completed = false
    
    override static func primaryKey() -> String? {
        return #keyPath(identifier)
    }
    
    override static func indexedProperties() -> [String] {
        return [#keyPath(completed), #keyPath(priority), #keyPath(date)]
    }
    
    override func toDictionary() -> [String: Any] {
        return [
            #keyPath(identifier): self.identifier,
            #keyPath(name): self.name,
            #keyPath(notes): self.notes,
            #keyPath(date): self.date,
            #keyPath(priority): self.priority,
            #keyPath(completed): self.completed
        ]
    }
    
    func detached() -> CoreTodoItem {
        return CoreTodoItem(value: self)
    }
}
