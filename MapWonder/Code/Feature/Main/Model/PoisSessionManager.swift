//
//  PoisSessionManager.swift
//  MapWonder
//
//  Created by Jaime Tejeiro on 23/2/23.
//

import Foundation


struct PoisSessionManager {
    
    static let tokenKey = "PoisToken"
    static let poisKey = "pois"
    static let poisSessionKey = "com.save.SessionManager"
    
    
    static var saveToken = { (token: String) in
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    static var savePois = { (pois: PoisResponse) in
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(pois) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: poisKey)
        }
    }
    
    static var getToken = {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    static func getPois()-> PoisResponse? {
        var poisResponse :PoisResponse?
        if let savedPerson = UserDefaults.standard.object(forKey: PoisSessionManager.poisKey ) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(PoisResponse.self, from: savedPerson) {
                poisResponse = loadedPerson
                return poisResponse
            }
        }
        return nil
    }
    
    static func poisRemove(){
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: poisKey)
    }
}
