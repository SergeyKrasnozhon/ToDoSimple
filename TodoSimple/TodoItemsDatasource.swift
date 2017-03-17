//
//  TodoItemsDatasource.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import Foundation
import RealmSwift

struct TodoItemsDatasource {
    private var notificationToken: NotificationToken?
    private let realm = RealmManager().realm()
    private let writer: PersistantWriter

    public var didChangeBlock: (() -> Void)? {
        didSet {
            if let block = self.didChangeBlock {
                self.updateNotificating(with: block)
            } else {
                self.notificationToken?.stop()
                self.notificationToken = nil
            }
        }
    }
    var needUseCompleted: Bool = true {
        didSet {
            self.didChangeBlock?()
        }
    }
    
    var filterString: String = "" {
        didSet {
            self.didChangeBlock?()
        }
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
    
    private mutating func updateNotificating(with block: @escaping () -> Void) {
        self.notificationToken = self.allItems().addNotificationBlock { changes in
            switch changes {
            case .initial: break
            case .update, .error: block()
            }
        }
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
