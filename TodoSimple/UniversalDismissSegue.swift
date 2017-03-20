//
//  UniversalDismissSegue.swift
//  TodoSimple
//
//  Created by Sergey on 3/20/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import UIKit

class UniversalDismissSegue: UIStoryboardSegue {    
    override func perform() {
        self.source.presentingViewController?.dismiss(animated: true, completion: nil)
        let _ = self.source.navigationController?.popViewController(animated: true)
    }
}
