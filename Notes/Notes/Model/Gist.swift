//
//  Gist.swift
//  Notes
//
//  Created by Надежда Морозова on 10/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

struct Gist: Codable {
    let files: [String: GistFile]
    var id: String
    let url: String?
}

struct GistFile: Codable {
    let filename: String
    let rawUrl: String?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case filename
        case rawUrl = "raw_url"
        case content
    }
    
}
var userToken = ""
let notesFileName = "ios-course-notes-db"
var gistsId = ""
var isNotesLoaded = false


let notebook = FileNotebook()
let backendQueue = OperationQueue()
let dbQueue = OperationQueue()
let commonQueue = OperationQueue()

