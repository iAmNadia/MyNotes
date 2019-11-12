
import XCTest
@testable import Notes

class FileNotebookTests: XCTestCase {

    var fileNotebook = FileNotebook()
    
    override func setUp() {
        super.setUp()
        fileNotebook = FileNotebook()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFileNotebookIsEmpty() {
        XCTAssertTrue(fileNotebook.notes.isEmpty)
    }
    
    func testAdd() {
        let note = Note(title: "title", content: "content", importance: Importance.normal)
        fileNotebook.add(note)
        
        XCTAssertEqual(fileNotebook.notes.count, 1)
    }
    
    func testAddSameIdNotes() {
        let note1 = Note(title: "title", content: "content", importance: Importance.normal)
        let note2 = Note(uid: note1.uid, title: "title2", content: "content2", importance: Importance.normal)
        fileNotebook.add(note1)
        XCTAssertEqual(fileNotebook.notes.count, 1)
        fileNotebook.add(note2)
        XCTAssertEqual(fileNotebook.notes.count, 1)
    }
    
    func testRemove() {
        let note = Note(title: "title", content: "content", importance: Importance.normal)
        fileNotebook.add(note)
        fileNotebook.remove(with: note.uid)
        XCTAssertTrue(fileNotebook.notes.isEmpty)
    }
    
    func testSaveAndLoad() {
        let note1 = Note(title: "title", content: "content", importance: Importance.normal)
        let note2 = Note(title: "title2", content: "content2", importance: Importance.important)
        fileNotebook.add(note1)
        fileNotebook.add(note2)
        fileNotebook.saveToFile()
        XCTAssertEqual(fileNotebook.notes.count, 2)
        fileNotebook.remove(with: note1.uid)
        fileNotebook.remove(with: note2.uid)
        XCTAssertTrue(fileNotebook.notes.isEmpty)
        fileNotebook.loadFromFile()
        XCTAssertEqual(fileNotebook.notes.count, 2)
    }
    
}
