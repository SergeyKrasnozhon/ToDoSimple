//
//  DismissSegue.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {
    override func perform() {
        self.source.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
