/**
 @file      SWAPIRequest.swift
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

import APIRequestObject

open class SWAPIRequest<T: NSObject>: APIRequest {

    public var successObjectAction: ((T?, HTTPURLResponse, Any?) -> Void)?
    public var successArrayAction: (([T]?, HTTPURLResponse, Any?) -> Void)?

    open override var responseHandler: APIResponseHandler {
        didSet {
            checkResponseSuccessClass()
        }
    }

    private func checkResponseSuccessClass() {
        let cls = T.self
        if NSStringFromClass(cls) != "NSObject", let response = self.responseHandler as? APIJSONResponse {
            response.successClass = cls
        }
    }

    private func convertSuccessFunction() {
        weak var wSelf = self
        onSuccess = {(object, response, data) in
            guard let me = wSelf else { return }
            var didIt = false
            if let obj = object as? T?, let action = me.successObjectAction {
                action(obj, response, data)
                didIt = true
            }
            if let objs = object as? [T]?, let action = me.successArrayAction {
                action(objs, response, data)
                didIt = true
            }
            if !didIt {
                if let obj = object as? T, let action = me.successArrayAction {
                    action([obj], response, data)
                } else if let action = me.successObjectAction {
                    action(nil, response, data)
                } else if let action = me.successArrayAction {
                    action(nil, response, data)
                }
            }
        }
        checkResponseSuccessClass()
    }

    public override init() {
        super.init()
        convertSuccessFunction()
    }

}
