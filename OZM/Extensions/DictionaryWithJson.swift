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
        let data = NSJSONSerialization.dataWithJSONObject(
            self as! AnyObject,
            options: nil,
            error: &error
        )
        return data
    }
}