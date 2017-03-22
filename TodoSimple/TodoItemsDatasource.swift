//
//  TodoItemsDatasource.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import Foundation
import RealmSwift

struct TodoItemsDatasourceChanges {
    let updatedItems: [(item: TodoItemAutoWrite, index: Int)]
    let deletions: [Int]
    let insertions: [Int]
}

struct TodoItemsDatasource {
    private var notificationToken: NotificationToken?
    private let realm = RealmManager().realm()
    private let writer: PersistantWriter

    var didChange: ((TodoItemsDatasourceChanges) -> Void)? {
        didSet { self.updateNotificating() }
    }
    
    var didUpdate: (() -> Void)? {
        didSet { self.updateNotificating() }
    }
    
    var needUseCompleted: Bool = true {
        didSet { self.updateNotificating() }
    }
    
    var filterString: String = "" {
        didSet { self.updateNotificating() }
    }
    
    init() {
        self.writer = PersistantWriter(relmInstance: self.realm)
    }
    
    func itemsCount() -> Int {
        return self.allItems().count
    }
    
    func item(at index: Int) -> TodoItemInmemory? {
        guard let coreItem = self.coreItem(at: index) else { return nil }
        return TodoItemCreator.inMemoryItem(with: coreItem, writer: self.writer)
    }
    
    func item(at index: Int) -> TodoItemAutoWrite? {
        guard let coreItem = self.coreItem(at: index) else { return nil }
        return TodoItemCreator.autoWriteItem(with: coreItem, writer: self.writer)
    }
    
    func templateItem() -> TodoItemInmemory {
        return TodoItemCreator.inMemoryItem(writer: self.writer)
    }
    
    //MARK: Service
    private func sortDescriptors() -> [SortDescriptor] {
        return [
            SortDescriptor(keyPath: CoreTodoItem.PropertyKey.completed, ascending: true),
            SortDescriptor(keyPath: CoreTodoItem.PropertyKey.priority, ascending: false),
            SortDescriptor(keyPath: CoreTodoItem.PropertyKey.date, ascending: true)
        ]
    }
    
    private func filterPredicate() -> NSPredicate {
        let nameFilter = self.namePredicate()
        let completionFilter = self.completionPredicat()
        return NSCompoundPredicate(andPredicateWithSubpredicates: [nameFilter, completionFilter])
    }
    
    private func completionPredicat() -> NSPredicate {
        if !self.needUseCompleted {
            return NSPredicate(format: "%K = %@", CoreTodoItem.PropertyKey.completed, false as CVarArg)
        }
        return NSPredicate(format: "TRUEPREDICATE")
    }
    
    private func namePredicate() -> NSPredicate {
        if !self.filterString.isEmpty {
            return NSPredicate(format: "%K CONTAINS[c] %@", CoreTodoItem.PropertyKey.name, self.filterString)
        }
        return NSPredicate(format: "TRUEPREDICATE")
    }
    
    private func createNotification() -> NotificationToken {
        return self.allItems().addNotificationBlock({ (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.didUpdate?()
            case .update(_, let deletions, let insertions, let modifications):
                let results = modifications.map({ (index) -> (TodoItemAutoWrite, Int)? in
                    guard let item:TodoItemAutoWrite = self.item(at: index) else { return nil }
                    return (item, index)
                }).flatMap { $0 }
                let changes = TodoItemsDatasourceChanges(updatedItems: results, deletions: deletions, insertions: insertions)
                self.didChange?(changes)
            case .error:
                break
            }
        })
    }
    
    private mutating func updateNotificating() {
        self.notificationToken?.stop()
        self.notificationToken = self.createNotification()
    }
    
    private func coreItem(at index: Int) -> CoreTodoItem? {
        let allItems = self.allItems()
        return (0..<allItems.count ~= index) ? allItems[index] : nil
    }
    
    private func allItems() -> Results<CoreTodoItem> {
        let allObjects = self.realm.objects(CoreTodoItem.self).filter(self.filterPredicate())
        return allObjects.sorted(by: self.sortDescriptors())
    }
}
