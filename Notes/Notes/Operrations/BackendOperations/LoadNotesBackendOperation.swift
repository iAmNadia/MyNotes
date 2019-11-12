//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by Надежда Морозова on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

enum LoadNotesBackendResult {
    case success([Note])
    case error(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: LoadNotesBackendResult?
    
    override func main() {
        
        if Storage.sharedId.isEmpty || Storage.contentLink.isEmpty {
            let stringUrl = "https://api.github.com/gists"
            guard let url = URL(string: stringUrl) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("token \(Github.Token)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    self.result = .error(.wrong)
                    self.finish()
                    return
                }
                
                guard let data = data else {
                    self.result = .error(.wrong)
                    self.finish()
                    return
                }
                
                guard let gists = try? JSONDecoder().decode([Gist].self, from: data) else {
                    self.result = .error(.unexpected)
                    self.finish()
                    return
                }
                
                if let gist = gists.first(where: {$0.files.keys.contains(Github.FileName)})  {
                    Storage.sharedId = gist.id
                    Storage.contentLink = gist.files[Github.FileName]?.rawUrl ?? ""
                    self.loadGist()
                }
            }
            task.resume()
        } else {
            loadGist()
        }
    }

private func loadGist() {
    guard let url = URL(string: Storage.contentLink) else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("token \(Github.Token)", forHTTPHeaderField: "Authorization")
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            self.result = .error(.wrong)
            self.finish()
            return
        }
        
        guard let data = data else {
            self.result = .error(.wrong)
            self.finish()
            return
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            self.result = .error(.unexpected)
            self.finish()
            return
        }
        
        var Notes = [Note]()
        json.forEach{ if let note = Note.parse(json: $0) { Notes.append(note) } }
        self.result = .success(Notes)
        self.finish()
    }
    task.resume()
    }
}
