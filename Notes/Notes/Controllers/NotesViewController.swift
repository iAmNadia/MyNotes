
import Foundation
import UIKit
import CoreData

class NotesViewController: UITableViewController {
    
    let reuseIdentifier = "noteCell"
    private let notebook = FileNotebook()
    private var first = true
    var backgroundContext: NSManagedObjectContext!
    private var fetchedResultsController: NSFetchedResultsController<ENote>?
    
    var context: NSManagedObjectContext! {
        didSet {
            setupFetchResultController(for: context)
            do {
                try
                    fetchedResultsController?.performFetch()
                tableView.reloadData()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Заметки"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickAddButton))
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(clickEditButton))
        navigationItem.rightBarButtonItem = add
        navigationItem.leftBarButtonItem = edit
        
        self.tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    private func requestToken() {
        let requestTokenViewController = LoginViewController()
        requestTokenViewController.delegate = self
        present(requestTokenViewController, animated: false, completion: nil)
    }
    
    @objc
    private func updateData() {
        
        DispatchQueue.main.async { [weak self] in
            print("Update data")
            guard let self = self else { return }
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    @objc public func clickAddButton() {
        let note = Note(title: "", content: "", importance: .normal)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EditNoteContr") as! EditNoteContr
        vc.delegate = self
        vc.notes = note
        vc.notebook = notebook
        vc.context = context
        vc.backgroundContext = backgroundContext
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc public func clickEditButton() {
        tableView.isEditing = !tableView.isEditing
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notebook.Notes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        cell.titleLabel.text = notebook.Notes[indexPath.row].title
        cell.contentLabel.text = notebook.Notes[indexPath.row].content
        cell.colorRect.backgroundColor = notebook.Notes[indexPath.row].color
        return cell
    }
    
    // Загружаем заметки
    func loadNotes() {
        let backendQueue = OperationQueue()
        let dbQueue = OperationQueue()
        
        let loadNotesOperation = LoadNotesOperation(
            notebook: notebook,
            backendQueue: backendQueue,
            dbQueue: dbQueue,
            context: context,
            backgroundContext: backgroundContext
        )
        loadNotesOperation.completionBlock = {
            DispatchQueue.main.async {
                print("reload data")
                self.tableView.reloadData()
            }
        }
        let loadQueue = OperationQueue()
        loadQueue.addOperation(loadNotesOperation)
    }
    
    // Удаляем заметку
    private func deleteNote(at indexPath: IndexPath) {
        let note = notebook.Notes[indexPath.row]
        
        let backendQueue = OperationQueue()
        let dbQueue = OperationQueue()
        let commonQueue = OperationQueue()
        
        let removeNoteOperation = RemoveNoteOperation(
            note: note,
            notebook: notebook,
            backendQueue: backendQueue,
            dbQueue: dbQueue,
            context: context,
            backgroundContext: backgroundContext
        )
        commonQueue.addOperation(removeNoteOperation)
    }
}

extension NotesViewController: NoteEditViewControllerDelegate {
    func noteUpdated(note: Note) {
        //notebook.add(note)
        //self.tableView.reloadData()
    }
}

extension NotesViewController {
    
    func setupFetchResultController(for context: NSManagedObjectContext) {
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        let request = NSFetchRequest<ENote>(entityName: "ENote")
        request.sortDescriptors = [ sortDescriptor ]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
    }
    
    private func fetchData() {
        try! fetchedResultsController?.performFetch()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EditNoteContr") as! EditNoteContr
        vc.delegate = self
        vc.notebook = notebook
        vc.notes = notebook.Notes[indexPath.row]
        vc.context = context
        vc.backgroundContext = backgroundContext
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(at: indexPath)
        }
    }
}


extension NotesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
}


extension NotesViewController: AuthViewControllerDelegate {
    func handleTokenChanged(token: String) {
        gistDB.setToken(token : token)
        updateData()
    }
}

extension NotesViewController: LoadNotesOperationDelegate {
    func handleDataUpdated() {
        updateData()
    }
}

extension NotesViewController {
    func loadTestData() {
        notebook.add(Note(
            title: "Моя заметка",
            content: "Для тестирования",
            importance: ImportanceType.normal,
            color: UIColor.init(rgbaHexString: "#2BA896")
        ))
    }
}
