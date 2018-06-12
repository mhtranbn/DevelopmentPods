/**
 @file      CMPopupManager.swift
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

import Foundation
import UIKit
import RSUtils

/// Popup client should follow this protocol to allow CMPopupManager managing how to show popup by mode
@objc public protocol CMPopupClient: class {
    /// Client does the animation to show up
    func doShowing(animation: Bool, isRestoreFromTemporary: Bool, completion: @escaping () -> Void)
    /// Client does the animation to hide/dissmiss
    func doHiding(animation: Bool, isTemporary: Bool, isForced: Bool, completion: @escaping () -> Void)

    /// For manager control
    var operationQueue: OperationQueue? { get set }
}

/**
 This class manages a custom window which helps popup clients showing separately with app window, also manages the flow to show popups.
 
 If client uses internal window to show popup, it must call `activiatePopupWindow()` to show up &
 `deactivatePopupWindow()` when it hides. If there is an other popup, the `deactivatePopupWindow()` does not hide the custom window.
 
 Popup modes:
 
 - All: When client calls `registToShow(popup:animate:)`, manager calls immediately `doShowing(animate:restoreFromTemporary:)`
 & add client into `waitingPopups` list. When client finishes hidding, it must call `popupDidHide(popup:)`, manager removes it
 from `waintingPopups` list.
 - Queue: when client calls `registToShow(popup:animate:)`, manager adds it into `waitingPopups` list,
 if `currentPopup` is nil, manager shows the first client in `waitingPopups` list as the `currentPopup`.
 When `currentPopup` finishes hidding (call `popupDidHide(popup:)`), manager continues to show the 1st
 client in `waitingPopups` list.
 - Statck: when client calls `registToShow(popup:animate:)`, manager adds `currentPopup` then it into
 `waitingPopups` list, wait the `currentPopup` to finish hiding, then show the last client in `waitingPopups` list.
 */
public class CMPopupManager: NSObject {

    /** Log category for **CommonLog** */
    @objc public static let kCMPopupLogCategory = "PUP"

    @objc public static var sharedInstance = CMPopupManager()
    private var clients = [CMPopupClient]()

    @objc public func registToShow(popup: CMPopupClient, animation: Bool) {
        var queue: OperationQueue
        if let que = popup.operationQueue {
            queue = que
        } else {
            queue = OperationQueue()
            queue.maxConcurrentOperationCount = 1
            popup.operationQueue = queue
        }
        execOnMain {
            if !CMPopupManager.sharedInstance.clients.containsRef(popup) {
                CMPopupManager.sharedInstance.clients.append(popup)
            }
        }
        queue.addOperation {
            var isFinished = false
            execOnMain {
                popup.doShowing(animation: animation, isRestoreFromTemporary: false) {
                    isFinished = true
                }
            }
            while !isFinished {
                sleep(0)
            }
        }
    }

    @objc public func registToHide(popup: CMPopupClient, animation: Bool, isAlreadyHidden: Bool) {
        guard let queue = popup.operationQueue else { return }
        queue.addOperation {
            if !isAlreadyHidden {
                var isFinished = false
                execOnMain {
                    popup.doHiding(animation: animation, isTemporary: false, isForced: false) {
                        isFinished = true
                    }
                }
                while !isFinished {
                    sleep(0)
                }
            }
            execOnMain {
                _ = CMPopupManager.sharedInstance.clients.removeRef(popup)
            }
        }
    }
    
}
