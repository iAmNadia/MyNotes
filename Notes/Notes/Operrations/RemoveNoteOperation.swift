//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by Надежда Морозова on 02/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import CoreData

class RemoveNoteOperation: AsyncOperation {
    
    private let removeFromDb: RemoveNoteDBOperation
    private let dbQueue: OperationQueue
    
    private(set) var result: SaveNotesBackendResult?
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         context: NSManagedObjectContext,
         backgroundContext: NSManagedObjectContext) {
        
        removeFromDb = RemoveNoteDBOperation(note: note, notebook: notebook, context: context, backgroundContext: backgroundContext)
        self.dbQueue = dbQueue
        
        super.init()
        
        removeFromDb.completionBlock = {
            let saveToBackend = SaveNotesBackendOperation(notes: notebook.Notes)
            saveToBackend.completionBlock = {
                self.result = saveToBackend.result
                self.finish()
            }
            backendQueue.addOperation(saveToBackend)
        }
    }
    
    override func main() {
        dbQueue.addOperation(removeFromDb)
    }
}
