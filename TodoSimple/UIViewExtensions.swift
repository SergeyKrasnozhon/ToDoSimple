//
//  UIViewExtensions.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import UIKit

extension UIView {
    public func ts_currentFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let responder = view.ts_currentFirstResponder() {
                return responder
            }
        }
        return nil
    }
}
