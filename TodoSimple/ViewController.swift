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
    private var isChild = false
    private var seguePrepareblocks = [String: PrepareBlock]()
    func performSegue(withIdentifier identifier: String, sender: Any?, setupBlock: @escaping PrepareBlock) {
        self.seguePrepareblocks[identifier] = setupBlock
        self.performSegue(withIdentifier: identifier, sender: sender)
    }

    override func addChildViewController(_ childController: UIViewController) {
        super.addChildViewController(childController)
        if let viewController = childController as? ViewController {
            viewController.isChild = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        let setupBlock: PrepareBlock? = self.seguePrepareblocks[identifier]
        setupBlock?(segue)
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController,
                                              withSender sender: Any) -> Bool {
        if fromViewController === self || self.isChild {
            return false // Just to be sure that we will not have segue with equal source and destination VC.
        }
        return true
    }
    
    @IBAction func unwindAutomatically(sender: UIStoryboardSegue)
    {
        //Needed to be able to connect from IB
    }
}
