//
//  DeleteTodoItemAction.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import Foundation
import RealmSwift

struct DeleteTodoItemAction {
    private let realm = RealmManager().realm()
    
    func execute(with item: TodoItemCommon) {
        let allItems = self.realm.objects(CoreTodoItem.self)
        let itemsToRemove = allItems.filter("%K = %@", #keyPath(CoreTodoItem.identifier), item.identifier)
        do {
            try self.realm.write {
                self.realm.delete(itemsToRemove)
            }
        } catch {
            Logger().log(message: "Cant delete items", error: error)
        }
    }
}
