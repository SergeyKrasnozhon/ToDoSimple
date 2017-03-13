//
//  ViewController.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    typealias PrepareBlock = (UIStoryboardSegue) -> Void

    private var seguePrepareblocks = [String: PrepareBlock]()
    func performSegue(withIdentifier identifier: String, sender: Any?, setupBlock: @escaping PrepareBlock) {
        self.seguePrepareblocks[identifier] = setupBlock
        self.performSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        let setupBlock: PrepareBlock? = self.seguePrepareblocks[identifier]
        setupBlock?(segue)
    }
}
