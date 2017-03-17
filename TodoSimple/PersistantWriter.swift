//
//  PersistantWriter.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import Foundation
import RealmSwift

struct PersistantWriter {
    typealias ExecutionBlock = () -> Void
    private let realm: Realm
    
    init(relmInstance: Realm) {
        self.realm = relmInstance
    }
    
    // MARK: 
    func context(for object: CoreObject) -> ((ExecutionBlock) -> Void) {
        let emptyBlock = { (block: ExecutionBlock) in }
        let writeBlock = self.writeBlock() ?? emptyBlock
        return self.isWriteAble(object: object) ? writeBlock : emptyBlock
    }
    
    func create<T: CoreObject>(with coreObject: T) -> T? {
        var result: T? = nil
        let writeContext = self.context(for: coreObject)
        writeContext {
            result = self.realm.create(type(of: coreObject), value: coreObject.toDictionary(), update: true)
        }
        return result
    }
    
    // MARK: Service
    private func writeBlock() -> ((ExecutionBlock) -> Void)? {
        return { (block: ExecutionBlock) in
            do {
                try self.realm.write { block() }
            } catch {
                Logger().log(message: "Cant write ", error: error)
            }
        }
    }

    private func isWriteAble(object: CoreObject) -> Bool {
        return !object.isInvalidated
    }
}
