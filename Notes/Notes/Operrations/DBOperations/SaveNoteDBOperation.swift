//
//  SaveNoteDBOperation.swift
//  Notes
//
//  Created by Надежда Морозова on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum SaveNotesDBResult {
    case success
    case failure
}
class SaveNoteDBOperation: BaseDBOperation {
    
    private let note: Note
    var result: SaveNotesDBResult?
    
    init(note: Note, notebook: FileNotebook,
         context: NSManagedObjectContext,
         backgroundContext: NSManagedObjectContext) {
        
        print("SaveNoteDBOperation.init")
        self.note = note
        super.init(notebook: notebook, context: context, backgroundContext: backgroundContext)
        
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc func managedObjectContextDidSave(notification: Notification) {
        context.perform {
            self.context.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    
    override func main() {
        print("SaveNoteDBOperation.main")
        saveToDB()
        result = .success
        
    }
    
    func saveToDB() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            let fetchRequest = NSFetchRequest<ENote>(entityName: "ENote")
            fetchRequest.predicate = NSPredicate(format: "uid = %@", self.note.uid)
            fetchRequest.fetchLimit = 1
            
            do {
                let notes = try self.backgroundContext.fetch(fetchRequest)
                
                if let n = notes.first {
                    n.uid = self.note.uid
                    n.title = self.note.title
                    n.content = self.note.content
                    n.importance = self.note.importance.rawValue
                     //n.color = self.note.color.rgbaHexString
                    let rgba = self.note.color.rgba
                    n.color = String(format: "%f,%f,%f,%f", arguments: [rgba.red, rgba.green, rgba.blue, rgba.alpha])
                    if let d = self.note.selfDestructionDate {
                        n.destruction_date = d.timeIntervalSince1970
                    }
                } else {
                    let n = ENote(context: self.backgroundContext)
                    n.uid = self.note.uid
                    n.title = self.note.title
                    n.content = self.note.content
                    n.importance = self.note.importance.rawValue
                    let rgba = self.note.color.rgba
                    n.color = String(format: "%f,%f,%f,%f", arguments: [rgba.red, rgba.green, rgba.blue, rgba.alpha])
                    if let d = self.note.selfDestructionDate {
                        n.destruction_date = d.timeIntervalSince1970
                    }
                }
                self.backgroundContext.performAndWait {
                    do {
                        try self.backgroundContext.save()
                        print("Save background ok")
                        self.notebook.add(self.note)
                    } catch {
                        print("Save background error: \(error)")
                    }
                }
            } catch {
                print("fetching error: \(error)")
            }
            self.finish()
        }
    }
}
