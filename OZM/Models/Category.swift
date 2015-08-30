//
//  Category.swift
//  OZM
//
//  Created by Semyon Novikov on 30/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation

public struct Categories: Deserializable {
    public var categories: [Category]?

    public init(data: JSONDictionary) {
        categories <-- data["categories"]
    }
}

public struct Category: Deserializable {
    public var id: Int?
    public var description: String?
    public var backgroundImage: String?
    public var promoBackgroundImage: String?
    public var isPinned: Bool?
    public var isPromo: Bool?
    public var promoEnd: String?
    public var showNew: Bool?
    public var isNew: Bool?

    public init(data: JSONDictionary) {
        id <-- data["id"]
        description <-- data["description"]
        backgroundImage <-- data["backgroundImage"]
        promoBackgroundImage <-- data["promoBackgroundImage"]
        isPinned <-- data["isPinned"]
        isPromo <-- data["isPromo"]
        promoEnd <-- data["promoEnd"]
        showNew <-- data["showNew"]
        isNew <-- data["isNew"]
    }
}
