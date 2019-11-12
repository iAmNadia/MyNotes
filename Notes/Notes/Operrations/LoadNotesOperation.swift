//
//  LoadNotesOperation.swift
//  Notes
//
//  Created by Надежда Морозова on 02/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import CoreData

class LoadNotesOperation: AsyncOperation {
    
    private let loadfromDb: LoadNotesDBOperation
    private let dbQueue: OperationQueue
    
    private(set) var error: NetworkError?
    
    private(set) var result: Bool? = false
    weak var delegate: LoadNotesOperationDelegate?
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         context: NSManagedObjectContext,
         backgroundContext: NSManagedObjectContext) {
        
        loadfromDb = LoadNotesDBOperation(notebook: notebook,
                                          context: context,
                                          backgroundContext: backgroundContext)
        
        self.dbQueue = dbQueue
        
        super.init()
        dbQueue.addOperation(self.loadfromDb)
        
    }
    override func main() {
        print("LoadNotesOperation.main")
        
        self.loadfromDb.completionBlock = {
            self.finish()
            print("loadFromDb.completionBlock")
        }
        self.addDependency(self.loadfromDb)
    }
}

protocol LoadNotesOperationDelegate: class {
    func handleDataUpdated()
}
