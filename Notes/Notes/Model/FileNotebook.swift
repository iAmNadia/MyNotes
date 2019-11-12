import UIKit

class FileNotebook {
    
    private(set) var Notes = [Note]()
    static var shared = FileNotebook()
    public init() {}
    public func add(_ note: Note) {
        if let index = Notes.firstIndex(where: { $0.uid == note.uid }) {
            Notes[index] = note
        } else {
            Notes.append(note)
        }
    }
    // добавления новой заметки
    public func addNew(_ note: Note){
        print("add note")
        if let index = self.Notes.firstIndex(where: { $0.uid == note.uid }) {
            self.Notes[index] = note
            print("note with uid = \(note.uid) already exists")
            return
        }
        Notes.append(note)
    }
    
    public func copyFrom(_ notes: [Note]) {
        self.Notes = notes
    }
    
    public func remove(with uid: String) {
        Notes.removeAll{ $0.uid == uid }
    }
    
    public func saveToFile() {
        if let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileUrl =  dir.appendingPathComponent("Notebook.txt")
            do {
                if FileManager.default.fileExists(atPath: fileUrl.path) {
                    try FileManager.default.removeItem(atPath: fileUrl.path)
                }
                let data = try JSONSerialization.data(withJSONObject: Notes.map{ $0.json}, options: [])
                FileManager.default.createFile(atPath: fileUrl.path, contents: data, attributes: nil)
            } catch {}
        }
    }
    public func getJSON() -> Data? {
        var notesJSONMap = [[String: Any]]()
        for n in Notes {
            notesJSONMap.append(n.json)
        }
        return try? JSONSerialization.data(withJSONObject: notesJSONMap, options: [])
    }
    // сохранение всей записной книжки в файл
    public func saveAllToFile(){
        guard let notesJSON = getJSON() else { return }
        
        do {
            let fileURL = getNotebookURL()
            try notesJSON.write(to: fileURL)
            print("Saved to file \(fileURL.path)")
        } catch {
            print(error)
        }
    }
    
    private func getNotebookURL () -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let dirurl = paths[0]
        var isDir : ObjCBool = false
        if FileManager.default.fileExists(atPath: dirurl.path, isDirectory: &isDir), isDir.boolValue {
        } else {
            try? FileManager.default.createDirectory(at: dirurl, withIntermediateDirectories: true, attributes: nil)
        }
        return dirurl.appendingPathComponent("FileNotebook.json")
    }
    
    public func loadFromFile() {
        if let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileUrl =  dir.appendingPathComponent("Notebook.txt")
            if FileManager.default.fileExists(atPath: fileUrl.path), let data = FileManager.default.contents(atPath: fileUrl.path) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        Notes = []
                        json.forEach{ if let note = Note.parse(json: $0) { add(note) } }
                    }
                } catch {}
            }
        }
    }
    
    public func loadFromJSON(data : Data) {
        do {
            if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                self.Notes.removeAll()
                for i in dict {
                    if let n = Note.parse(json: i) {
                        self.add(n)
                    }
                }
            }
        } catch {
            print("Error parse JSON : \(error)")
        }
    }
    
    public func loadFromAllFile(){
        do {
            let fileURL = getNotebookURL()
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let data = try Data(contentsOf: fileURL)
                loadFromJSON(data: data)
                print("Load from file \(fileURL.path)")
            }
        } catch {
            print(error)
        }
    }
}


