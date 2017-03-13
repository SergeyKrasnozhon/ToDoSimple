//
//  TodoItem.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import Foundation


protocol TodoItemCommon {
    var identifier: String { get }
    var name: String { get set }
    var notes: String { get set }
    var priority: Int { get set }
    var date: Date { get set }
    var completed: Bool { get set }
    
    func toDictionary() -> [String: Any]
}

protocol TodoItemInmemory: TodoItemCommon {
    init(coreItem: CoreTodoItem, writer: PersistantWriter)
    func persist()
}

protocol TodoItemAutoWrite: TodoItemCommon {
    init(coreItem: CoreTodoItem, writer: PersistantWriter)
}

struct TodoItemCreator {
    private init() {}
    static func autoWriteItem(with coreItem: CoreTodoItem, writer: PersistantWriter) -> TodoItemAutoWrite {
        if coreItem.realm == nil {
            let createdCoreItem = writer.create(with: coreItem) ?? coreItem
            return TodoItemWrapper(coreItem: createdCoreItem, writer: writer)
        }
        return TodoItemWrapper(coreItem: coreItem, writer: writer)
    }
    
    static func inMemoryItem(with coreItem: CoreTodoItem = CoreTodoItem(), writer: PersistantWriter) -> TodoItemInmemory {
        return TodoItemWrapper(coreItem: coreItem.detached(), writer: writer)
    }
}

private struct TodoItemWrapper: TodoItemInmemory, TodoItemAutoWrite {
    private let coreItem: CoreTodoItem
    private let writer: PersistantWriter
    
    init(coreItem: CoreTodoItem, writer: PersistantWriter) {
        self.coreItem = coreItem
        self.writer = writer
    }
    
    // MARK: TodoItemCommon
    var identifier: String {
        return self.coreItem.identifier
    }
    
    var name: String {
        get { return self.coreItem.name }
        set {
            let context = self.writer.context(for: self.coreItem)
            context { self.coreItem.name = newValue }
        }
    }
    
    var priority: Int {
        get { return self.coreItem.priority }
        set {
            let context = self.writer.context(for: self.coreItem)
            context { self.coreItem.priority = newValue }
        }
    }
    
    var date: Date {
        get { return self.coreItem.date }
        set {
            let context = self.writer.context(for: self.coreItem)
            context { self.coreItem.date = newValue }
        }
    }
    
    var completed: Bool {
        get { return self.coreItem.completed }
        set {
            let context = self.writer.context(for: self.coreItem)
            context { self.coreItem.completed = newValue }
        }
    }
    
    var notes: String {
        get { return self.coreItem.notes }
        set {
            let context = self.writer.context(for: self.coreItem)
            context { self.coreItem.notes = newValue }
        }
    }
    
    func toDictionary() -> [String: Any] {
        return self.coreItem.toDictionary()
    }
    
    // MARK: TodoItemInmemoryble
    func persist() {
        let _ = self.writer.create(with: self.coreItem)
    }
}
