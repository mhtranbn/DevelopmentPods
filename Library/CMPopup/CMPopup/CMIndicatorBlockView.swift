/**
 @file      CMIndicatorBlockView.swift
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

import UIKit

/** Sample block view using indicator */
public class CMIndicatorBlockView: UIView, CMBlockViewProtocol {
    
    private weak var indicator: UIActivityIndicatorView?
    
    public convenience init(){
        self.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    }
    
    required public init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.layer.cornerRadius = ((frame.size.width + frame.size.height) / 2) / 8.0
        
        let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        view.hidesWhenStopped = true
        view.stopAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        var constraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal,
                                            toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        self.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal,
                                        toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        self.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal,
                                        toItem: self, attribute: .width, multiplier: 2.0 / 3.0, constant: 0)
        self.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal,
                                        toItem: self, attribute: .height, multiplier: 2.0 / 3.0, constant: 0)
        self.addConstraint(constraint)
        indicator = view
    }
    
    public func blockViewControllerWillAppear(_ sender: CMBlockViewController, animated: Bool){
        indicator?.startAnimating()
    }
    
    public func blockViewControllerDidDisappear(_ sender: CMBlockViewController, animated: Bool){
        indicator?.stopAnimating()
    }
    
}
