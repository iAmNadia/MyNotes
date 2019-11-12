//
//  GitHub.swift
//  Notes
//
//  Created by Надежда Морозова on 10/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

let gistDB = Github()

struct Github {
    static let AuthUrl = "https://github.com/login/oauth/authorize"
    static let ClientSecret = "!!!!!Введите свой ClientSecret"
    static let ClientId = "!!!!!Введите свой Id"
    static let RedirectUrl = "https://github.com/"
    static let Scope = "gist"
    static var Token = ""
    static var FileName = "ios-course-notes-db"
   
    func setToken(token : String){
        Github.self.Token = token
        }
}
