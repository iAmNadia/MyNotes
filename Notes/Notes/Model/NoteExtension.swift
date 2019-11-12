import UIKit
extension Note {
    var json: [String: Any] {
        get {
            var jsonMap = [String: Any]()
            jsonMap["uid"] = self.uid
            jsonMap["title"] = self.title
            jsonMap["content"] = self.content
            //Если цвет НЕ белый, сохраняет его в json
            if self.color != UIColor.white {
                var red : CGFloat = 0
                var green : CGFloat = 0
                var blue : CGFloat = 0
                var alpha : CGFloat = 0
                if self.color.getRed(&red, green: &green, blue: &blue, alpha: &alpha){
                    jsonMap["color"] = ["red" : Int(red*100), "green" : Int(green*100), "blue" : Int(blue*100), "alpha" : Int(alpha*100)]
                }
            }
            // Если важность «обычная», НЕ сохраняет её в json
            if self.importance != ImportanceType.normal {
                jsonMap["importance"] = self.importance.rawValue
            }
            if let selfDestructionDate = self.selfDestructionDate {
                jsonMap["selfDestructionDate"] = selfDestructionDate.timeIntervalSince1970
            }
            
            return jsonMap
        }
    }
    
    static func parse(json: [String: Any]) -> Note? {
        guard let uid = json["uid"] as? String else {
            return nil
        }
        guard let title = json["title"] as? String else {
            return nil
        }
        guard let content = json["content"] as? String else {
            return nil
        }
        
        // Если цвет не задан, устанавливаем белый цвет
        var color : UIColor = .white
        if json["color"] != nil {
            guard let ColorMap = json["color"] as? [String: Int] else {
                return nil
            }
            if let red = ColorMap["red"], let green = ColorMap["green"], let blue = ColorMap["blue"], let alpha = ColorMap["alpha"] {
                color = UIColor(red: CGFloat(red)/100.0, green:CGFloat(green)/100.0, blue: CGFloat(blue)/100.0, alpha: CGFloat(alpha)/100.0)
            }
        }
        // Если важность не задана, устанавливаем «обычная»
        var importance : ImportanceType = .normal
        if json["importance"] != nil {
            guard let importanceStr = json["importance"] as? String else {
                return nil
            }
            if let impfromraw = ImportanceType(rawValue: importanceStr) {
                importance = impfromraw
            } else {
                return nil
            }
        }
        // Если дата не задана, устанавливаем nil
        var selfDestructionDate : Date? = nil
        if let selfDestructionDateUnix = json["selfDestructionDate"] as? Double {
            selfDestructionDate = Date(timeIntervalSince1970: selfDestructionDateUnix)
        }
        
        return Note(title: title, content: content, importance: importance, uid: uid, color: color,  selfDestructionDate: selfDestructionDate)
    }
}
