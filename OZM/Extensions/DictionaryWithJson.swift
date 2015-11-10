//
//  DictionaryWithJson.swift
//  OZM
//
//  Created by Semyon Novikov on 30/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation

extension Dictionary {

    func jsonData() -> NSData? {
        var error: NSError? = nil
        let data: NSData?
        do {
            data = try NSJSONSerialization.dataWithJSONObject(
                        self as! AnyObject,
                        options: [])
        } catch let error1 as NSError {
            error = error1
            data = nil
        }
        return data
    }
}