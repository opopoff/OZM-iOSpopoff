//
//  History.swift
//  OZM
//
//  Created by Semyon Novikov on 22/10/15.
//  Copyright © 2015 ozm. All rights reserved.
//

import Foundation

let HistoryArchive = HistoryArchiveStorage(archivePath: "")

protocol HistoryStorage {
    mutating func add(image: Image)
    func images() -> [Image]
    func save()
}

struct HistoryArchiveStorage: HistoryStorage {
    let archivePath: String
    var history: [Image] = []

    init(archivePath: String) {
        self.archivePath = archivePath
    }

    mutating func add(image: Image) {
        history.append(image)
    }

    func save() {
    }

    func images() -> [Image] {
        return history
    }
}

struct History {
    var storage: HistoryStorage

    init(storage: HistoryStorage) {
        self.storage = storage
    }

    mutating func add(image: Image) {
        self.storage.add(image)
    }

    func images() -> [Image] {
        return self.storage.images()
    }
}