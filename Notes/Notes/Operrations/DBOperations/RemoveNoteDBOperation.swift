//
//  RemoveNoteDBOperation.swift
//  Notes
//
//  Created by Надежда Морозова on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class RemoveNoteDBOperation: BaseDBOperation {
    
    private let note: Note
    init(note: Note,
         notebook: FileNotebook, context: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        
        print("RemoveNoteDBOperation.init")
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
        print("RemoveNoteDBOperation.main")
        
        
        removeFromDB()
        notebook.remove(with: note.uid)
        print("notebook.remove ok")
        //finish()
    }
    
    func removeFromDB() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            let fetchRequest = NSFetchRequest<ENote>(entityName: "ENote")
            fetchRequest.predicate = NSPredicate(format: "uid = %@", self.note.uid)
            fetchRequest.fetchLimit = 1
            
            do {
                let notes = try self.backgroundContext.fetch(fetchRequest)
                if let n = notes.first {
                    self.backgroundContext.delete(n)
                    self.backgroundContext.performAndWait {
                        do {
                            try self.backgroundContext.save()
                            //try self.notebook.remove(with: self.uid)
                        } catch {
                            print("Saving background remove db error: \(error)")
                        }
                    }
                }
            } catch {
                print("Delete note error: \(error)")
            }
            print("remove from db ok®")
            self.finish()
        }
    }
}
