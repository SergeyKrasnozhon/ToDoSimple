//
//  KeyboardHandler.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import UIKit

class KeyboardHandler {
    private var subscribedForNotificiations: Bool = false
    private let rootView: UIView
    private let processIntersection: (CGFloat) -> Void
    
    init(rootView: UIView, processIntersection: @escaping (CGFloat) -> Void) {
        self.rootView = rootView
        self.processIntersection = processIntersection
    }
    
    func registerNotifications() {
        if self.subscribedForNotificiations { return }
        NotificationCenter.default.addObserver(self, selector:
            #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil
        )
        NotificationCenter.default.addObserver(self, selector:
            #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil
        )
    }
    
    func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.subscribedForNotificiations = false
    }
    
    dynamic private func keyboardWillShow(_ notification: Notification) {
        let notificationInfo = notification.userInfo
        let keyboardFrame = (notificationInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        guard let firstResponder = self.rootView.ts_currentFirstResponder() else {
            self.processIntersection(0)
            return
        }
        let targetFrame = self.rootView.convert(firstResponder.frame, from: firstResponder.superview)
        if keyboardFrame.intersects(targetFrame) {
            self.processIntersection(targetFrame.maxY - keyboardFrame.minY)
        } else {
            self.processIntersection(0)
        }
    }
    
    dynamic private func keyboardWillHide(_ notification: Notification) {
        self.processIntersection(0)
    }
}
