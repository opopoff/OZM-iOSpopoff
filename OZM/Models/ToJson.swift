//
//  ToJson.swift
//  OZM
//
//  Created by Semyon Novikov on 08/11/15.
//  Copyright © 2015 ozm. All rights reserved.
//

import Foundation

public protocol ToJson {
    func toJson() -> Dictionary<String, AnyObject>
}