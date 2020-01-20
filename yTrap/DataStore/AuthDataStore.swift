//
//  AuthDataStore.swift
//  yTrap
//
//  Created by Pawan on 2020-01-10.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation

class AuthDataStore {
    enum Key: String, CaseIterable {
        case accessToken, refreshToken, expireHour, userData
        func make(for userID: String) -> String {
            return self.rawValue + "_" + userID
        }
    }
    let userDefaults: UserDefaults
    // MARK: - Lifecycle
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    // MARK: - API
    func storeAccessInfo(accessToken:String, refreshToken:String,expireHour:String){
        saveValue(forKey: .accessToken, value: accessToken, userID: "accessToken")
        saveValue(forKey: .refreshToken, value: refreshToken, userID: "refreshToken")
        saveValue(forKey: .expireHour, value: expireHour, userID: "expireHour")
    }
    
    func getAccessInfo()->(String?, String?, String?){
        let accessToken:String? = readValue(forKey: .accessToken, userID: "accessToken")
        let refreshToken:String? = readValue(forKey: .refreshToken, userID: "refreshToken")
        let expireTime:String? = readValue(forKey: .expireHour, userID: "expireHour")
        return (accessToken,refreshToken,expireTime)
    }
    
    func storeUserData(forUser user:User){
        let encoder = JSONEncoder()
        if let encodedUserData = try? encoder.encode(user) {
            saveValue(forKey: .userData, value: encodedUserData, userID: "userData")
        }
    }
    
    func getUserData()->(User?){
      
        let decoder = JSONDecoder()
        if  let userData = readObject(forKey: .userData, userID: "userData"),
            let loadedPerson = try? decoder.decode(User.self, from: userData) {
            return loadedPerson
        }
        return nil
    }
 
    func removeUserInfo(forUserID userID: String) {
        Key
            .allCases
            .map { $0.make(for: userID) }
            .forEach { key in
                userDefaults.removeObject(forKey: key)
        }
    }
    // MARK: - Private
    private func saveValue(forKey key: Key, value: Any, userID: String) {
        userDefaults.set(value, forKey: key.make(for: userID))
    }
    private func readValue<T>(forKey key: Key, userID: String) -> T? {
        return userDefaults.value(forKey: key.make(for: userID)) as? T
    }
    private func readObject(forKey key: Key, userID: String) -> Data? {
        return userDefaults.object(forKey:  key.make(for: userID)) as? Data
       }
    private func readValue(forKey key: Key, userID: String) -> Data {
           return userDefaults.value(forKey: key.make(for: userID)) as! Data
       }
}
