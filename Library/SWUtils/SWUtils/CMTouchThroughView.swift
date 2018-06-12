/**
 @file      CMTouchThroughView.swift
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

import UIKit

open class CMTouchThroughView: UIView {

    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for view in self.subviews {
            let subPoint = self.convert(point, to: view)
            if let testView = view.hitTest(subPoint, with: event) {
                return testView
            }
        }
        return nil
    }

}
