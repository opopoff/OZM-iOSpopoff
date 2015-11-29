//
//  DefaultColors.swift
//  OZM
//
//  Created by Semyon Novikov on 29/11/15.
//  Copyright © 2015 ozm. All rights reserved.
//

import Foundation

struct DefaultColors {

    static var currentIndex = 0

    static let colors = [
        UIColor(rgba: "#E82B35"),
        UIColor(rgba: "#FFC526"),
        UIColor(rgba: "#EBE48C"),
        UIColor(rgba: "#1D9D90"),
        UIColor(rgba: "#ED650D")
    ]

    static func randomColor() -> UIColor {
        if currentIndex >= colors.count {
            currentIndex = 0
        }
        let color = colors[currentIndex]
        currentIndex++
        return color
    }
}