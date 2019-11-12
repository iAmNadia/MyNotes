//
//  LoadNoteDBOperation.swift
//  Notes
//
//  Created by Надежда Морозова on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum LoadNotesDBResult {
    case success
    case failure
}

class LoadNotesDBOperation: BaseDBOperation {
    
    var result: LoadNotesDBResult?
    
    override func main() {
        print("LoadNotesDBOperation.main")
        loadFromDB()
        result = .success
    }
    
    func loadFromDB() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            let fetchRequest = NSFetchRequest<ENote>(entityName: "ENote")
            do {
                let notes = try self.backgroundContext.fetch(fetchRequest)
                var newNotes = [Note]()
                
                for n in notes {
                    newNotes.append(
                        Note(title: n.title!,
                             content: n.content!,
                             importance: ImportanceType(rawValue: n.importance!)!,
                             uid: n.uid!,
                             // цвет не получилось доделать(
                             color: UIColor.init(rgbaHexString: n.color!),
                             selfDestructionDate: n.destruction_date > 0 ? Date(timeIntervalSince1970: n.destruction_date) : nil
                        )
                    )
                }
                self.notebook.copyFrom(newNotes)
            } catch {
                print("loadFromDB error: \(error)")
            }
            self.finish()
        }
    }
    
}
