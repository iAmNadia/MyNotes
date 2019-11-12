//
//  SaveNoteOperation.swift
//  Notes
//
//  Created by Надежда Морозова on 02/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import CoreData

class SaveNoteOperation: AsyncOperation {
    
    private let saveToDb: SaveNoteDBOperation
    private let dbQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         context: NSManagedObjectContext,
         backgroundContext: NSManagedObjectContext) {
        
        print("SaveNoteOperation.init")
        saveToDb = SaveNoteDBOperation(note: note, notebook: notebook, context: context, backgroundContext: backgroundContext)
        self.dbQueue = dbQueue
        
        super.init()
        
        dbQueue.addOperation(saveToDb)
        
    }
    
    override func main() {
        print("SaveNoteOperation.main")
        //dbQueue.addOperation(saveToDb)
        self.saveToDb.completionBlock = {
            print("Save to DB")
            self.result = true
            self.finish()
        }
        addDependency(saveToDb)
        
    }
}
