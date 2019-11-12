import UIKit

enum ImportanceType: String {
    case unimportant = "unimportant"
    case normal = "normal"
    case important = "important"
}

struct Note {
    let uid : String
    let title : String
    let content : String
    let color : UIColor
    let importance : ImportanceType
    let selfDestructionDate : Date?
    
    init(title : String, content : String,  importance : ImportanceType, uid : String? = nil, color : UIColor? = nil, selfDestructionDate : Date? = nil ) {
        self.uid = uid ?? UUID().uuidString
        self.color = color ?? UIColor.white
        self.title = title
        self.content = content
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
    }
}

extension Note: Comparable {
    static func < (lhs: Note, rhs: Note) -> Bool {
        return false
    }
    
    static func == (lhs: Note, rhs: Note) -> Bool {
        if
            lhs.uid == rhs.uid
                && lhs.title == rhs.title
                && lhs.content == rhs.content
                && lhs.color == rhs.color
                && lhs.importance == rhs.importance
                && lhs.selfDestructionDate == rhs.selfDestructionDate {
            return true
        }
        return false
    }
    
}
