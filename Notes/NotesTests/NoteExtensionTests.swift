

import XCTest
@testable import Notes

class NoteExtensionTests: XCTestCase {
    
    var note = Note(title: "title", content: "content", importance: Importance.normal)

    override func setUp() {
        super.setUp()
        note = Note(title: "title", content: "content", importance: Importance.normal)
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testParseEmptyJson() {
        let json = [String : Any]()
        let note = Note.parse(json: json)
        XCTAssertNil(note)
    }
    
    func testJsonNotEmpty() {
        let json = note.json
        XCTAssertFalse(json.isEmpty)
    }
    
    func testWhiteColorNotSave() {
        XCTAssertEqual(note.color, UIColor.white)
        let json = note.json
        XCTAssertNil(json["color"])
    }
    
    func testNormalImportanceNotSave() {
        let json = note.json
        XCTAssertNil(json["importance"])
    }
    
    func testParse() {
        let note = Note(title: "title", content: "content", color: .red, importance: Importance.important, selfDestructionDate: Date())
        let json = note.json
        let noteParseOptional = Note.parse(json: json)
        guard let noteParse = noteParseOptional else {
            XCTFail()
            return
        }
        XCTAssertEqual(note.uid, noteParse.uid)
        XCTAssertEqual(note.title, noteParse.title)
        XCTAssertEqual(note.content, noteParse.content)
        XCTAssertEqual(note.color, noteParse.color)
        XCTAssertEqual(note.importance, noteParse.importance)
        guard let noteSelfDD = note.selfDestructionDate,
            let noteParseSelfDD = noteParse.selfDestructionDate else {
                XCTFail()
                return
        }
        XCTAssertEqual(noteSelfDD.timeIntervalSince1970, noteParseSelfDD.timeIntervalSince1970)
        
    }

}
