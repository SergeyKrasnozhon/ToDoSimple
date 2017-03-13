//
//  RealmManager.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmManager {
    private static var realmInstance: Realm!
    
    static func initialize() {
        var configuration = Realm.Configuration()
        let baseUrl = configuration.fileURL!.deletingLastPathComponent()
        configuration.fileURL = baseUrl.appendingPathComponent("todo_storage.realm")

        RealmManager.realmInstance = try? Realm(configuration: configuration)
    }
    
    init() {
        if RealmManager.realmInstance == nil {
            Logger().log(message: "RealmManager: not initialized.")
            fatalError()
        }
    }
    
    func realm() -> Realm {
        return RealmManager.realmInstance
    }
}
