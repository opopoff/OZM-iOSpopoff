//
//  RegistrationResult.swift
//  OZM
//
//  Created by Semyon Novikov on 27/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation

/**
    Модель ответа сервера на регистрацию. 
    Используется для хранения секретов пользователя.
 */
public struct RegistrationResult: Deserializable {
    public var userKey: String?
    public var secretKey: String?

    public init(data: JSONDictionary) {
        self.userKey <-- data["key"]
        self.secretKey <-- data["secret"]
    }

    public init(userKey: String, secretKey: String) {
        self.userKey = userKey
        self.secretKey = secretKey
    }

    /**
        Попытается достать из Keychain необходимые ключи и создать RegistrationResult.
        Если в Keychain пусто, то ничего не выйдет.
     */
    public static func fromKeychain() -> RegistrationResult? {
        let (data, error) = Locksmith.loadDataForUserAccount(
            KeychainConstants.account,
            inService: KeychainConstants.service
        )
        if let
            data = data,
            key = data["key"] as? String,
            secret = data["secret"] as? String {
                return RegistrationResult(userKey: key, secretKey: secret)
        }
        if let error = error {
            println(error)
        }
        return nil
    }

    /**
        Сохраняет эту конкретную запись в Keychain.
        
        Возвращает true если получилось и false, если нет.

        :Ахтунг!: Метод *перезапишет* уже существующие в Keychain данные
     */
    public func save() -> Bool {
        if let
            key = self.userKey,
            secret = self.secretKey {
                let error = Locksmith.updateData(
                    ["key": key, "secret": secret],
                    forUserAccount: KeychainConstants.account,
                    inService: KeychainConstants.service
                )
                if let error = error {
                    println(error)
                    return false
                }
                return true
        }
        return false
    }
}
