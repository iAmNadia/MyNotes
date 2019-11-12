//
//  SaveNotesBackendOperations.swift
//  Notes
//
//  Created by Надежда Морозова on 31/07/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    private let notes: [Note]
    
    init(notes: [Note]) {
        self.notes = notes
        super.init()
    }
    
    override func main() {
        var stringUrl = "https://api.github.com/gists"
        var method = "POST"
        if !Storage.sharedId.isEmpty {
            stringUrl += "/\(Storage.sharedId)"
            method = "PATCH"
        }
        
        if let url = URL(string: stringUrl),
            let jsonData = try? JSONSerialization.data(withJSONObject: notes.map{ $0.json}, options: []),
            let content = String(data: jsonData, encoding: String.Encoding.utf8),
            let body = try? JSONEncoder().encode(Gist(files:
                [Github.FileName : GistFile(filename: Github.FileName, rawUrl: Storage.contentLink, content: content)], id: Storage.sharedId, url: nil)){
            var request = URLRequest(url: url)
            request.httpMethod = method
            
            request.httpBody = body
            request.addValue("token \(Github.Token)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    self.result = .failure(.wrong);
                    self.finish()
                    return
                }
                
                guard let data = data else {
                    self.result = .failure(.unexpected);
                    self.finish()
                    return
                }
                
                guard let gist = try? JSONDecoder().decode(Gist.self, from: data) else {
                    self.result = .failure(.unexpected)
                    self.finish()
                    return
                }
                Storage.contentLink = gist.files[Github.FileName]?.rawUrl ?? ""
                Storage.sharedId = gist.id
                
                self.result = .success
                self.finish()
            }
            task.resume()
        }
    }
}
