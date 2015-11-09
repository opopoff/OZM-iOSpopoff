//
//  Actions.swift
//  OZM
//
//  Created by Semyon Novikov on 08/11/15.
//  Copyright © 2015 ozm. All rights reserved.
//

import Foundation
import JSONHelper

public struct ImageActionData: Deserializable, ToJson {
    public var imageId: Int?;
    public var time: Int?;
    public var categorySourcePersonal: Bool?;
    public var categorySource: Int?;

    public init(data: JSONDictionary) {
        imageId <-- data["imageId"]
        time <-- data["time"]
        categorySourcePersonal <-- data["categorySourcePersonal"]
        categorySource <-- data["categorySource"]
    }

    public init(image: Image) {
        imageId = image.id
        time = Int(NSDate().timeIntervalSince1970)
        categorySourcePersonal = true
        categorySource = image.categoryId
    }

    public func toJson() -> Dictionary<String, AnyObject>  {
        let dict: Dictionary<String, AnyObject> = [
            "imageId": self.imageId ?? -1,
            "time": self.time ?? 0,
            "categorySourcePersonal": self.categorySourcePersonal ?? true,
            "categorySource": self.categorySource ?? -1
        ]

        return dict
    }
}

public struct Actions: Deserializable, ToJson {
    public var likes: [ImageActionData]?

    public init(data: JSONDictionary) {
        likes <-- data["likes"]
    }

    public init() {
        
    }

    public func toJson() -> Dictionary<String, AnyObject> {
        if let likes = likes {
            return [
                "likes": likes.map { d in d.toJson() }
            ]
        }
        return [:]
    }
}