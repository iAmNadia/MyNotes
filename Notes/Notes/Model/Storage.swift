//
//  Storage.swift
//  Notes
//
//  Created by Надежда Морозова on 10/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

struct Storage {
    static let GistIdKey = "gistId"
    static let GistContentKey = "gistContent"
    
    private static var _sharedId = ""
    public static var sharedId: String {
        get {
            if _sharedId.isEmpty, let gistId = UserDefaults.standard.string(forKey: Storage.GistIdKey) {
                _sharedId = gistId
            }
            return _sharedId
        }
        
        set(newValue) {
            _sharedId = newValue
            if !_sharedId.isEmpty {
                UserDefaults.standard.set(_sharedId, forKey: Storage.GistIdKey)
            }
        }
    }
    
    private static var _contentLink = ""
    public static var contentLink: String {
        get {
            if _contentLink.isEmpty, let link = UserDefaults.standard.string(forKey: Storage.GistContentKey) {
                _contentLink = link
            }
            return _contentLink
        }
        
        set(newValue) {
            _contentLink = newValue
            if !_contentLink.isEmpty {
                UserDefaults.standard.set(_contentLink, forKey: Storage.GistContentKey)
            }
        }
    }
    
    public static func invalidate() {
        UserDefaults.standard.removeObject(forKey: Storage.GistContentKey)
        UserDefaults.standard.removeObject(forKey: Storage.GistIdKey)
        _contentLink = ""
        _sharedId = ""
    }
}
