//
//  BaseDBOperation.swift
//  Notes
//
//  Created by Надежда Морозова on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import CoreData

class BaseDBOperation: AsyncOperation {
    let notebook: FileNotebook
    var backgroundContext: NSManagedObjectContext!
    var context: NSManagedObjectContext!
    
        init(notebook: FileNotebook, context: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
             print("BaseDBOperation.init")
            
            self.backgroundContext = backgroundContext
            self.context = context
            
            self.notebook = notebook
            super.init()
        }
    }
