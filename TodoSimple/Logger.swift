//
//  Logger.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import Foundation

struct Logger {
    func log(message: String, error: Error? = nil) {
        if let error = error {
            print(message + ": \(error)")
        } else {
            print(message)
        }
    }
}
