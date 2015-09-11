//
//  Image.swift
//  OZM
//
//  Created by Semyon Novikov on 30/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation
import UIKit

public struct Image: Deserializable {
    public var id: Int?
    public var url: String?
    public var sharingUrl: String?
    public var videoUrl: String?
    public var thumbnailUrl: String?
    public var categoryId: Int?
    public var categoryDescription: String?
    public var liked: Bool?
    public var shared: Bool?
    public var width: Int?
    public var height: Int?
    public var thumbnailWidth: Int?
    public var thumbnailHeight: Int?
    public var isGIF: Bool?
    public var isNew: Bool?
    public var isNewBlink: Bool?
    public var mainColor: String?
    public var timeUsed: Int?

    public init(data: JSONDictionary) {
        id <-- data["id"]
        url <-- data["url"]
        sharingUrl <-- data["sharingUrl"]
        videoUrl <-- data["videoUrl"]
        thumbnailUrl <-- data["thumbnailUrl"]
        categoryId <-- data["categoryId"]
        categoryDescription <-- data["categoryDescription"]
        liked <-- data["liked"]
        shared <-- data["shared"]
        width <-- data["width"]
        height <-- data["height"]
        thumbnailWidth <-- data["thumbnailWidth"]
        thumbnailHeight <-- data["thumbnailHeight"]
        isGIF <-- data["isGIF"]
        isNew <-- data["isNew"]
        isNewBlink <-- data["isNewBlink"]
        mainColor <-- data["mainColor"]
        timeUsed <-- data["timeUsed"]
    }


    public func thumbSize() -> CGSize? {
        if let
            width = thumbnailWidth,
            height = thumbnailHeight {
                return CGSize(
                    width: Double(width) / 2.0,
                    height: Double(height) / 2.0
                )
        }
        return nil
    }
}