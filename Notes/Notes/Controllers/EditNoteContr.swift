//
//  EditNoteContr.swift
//  Notes
//
//  Created by Надежда Морозова on 10/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import CoreData


protocol NoteEditViewControllerDelegate: class {
    func noteUpdated(note: Note)
}
class EditNoteContr: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    var notebook: FileNotebook?
    var backgroundContext: NSManagedObjectContext!
    var context: NSManagedObjectContext!
    weak var delegate: NoteEditViewControllerDelegate?
   // private var currentColor: ChosenColour = .white
    
    @IBOutlet var cvColors: UICollectionView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tvContent: UITextView!
    @IBOutlet var cnstrColorsToDatePicker: NSLayoutConstraint!
    @IBOutlet var cnstrBottomToView: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var tfTitle: UITextField!
    var onDone: ((Note) -> ())?
    @IBOutlet var switchDestroyDate: UISwitch!
    
    var colors = [UIColor.white, UIColor.red, UIColor.cyan]
     var notes: Note?
    //var note: Note = Note(title: "", content: "", importance: .normal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvContent.delegate = self
        tvContent.text = ""
        cvColors.delegate = self
        cvColors.dataSource = self
        cnstrColorsToDatePicker.isActive = false
        
        
        if let notes = notes {
        tfTitle.text = notes.title
        tvContent.text = notes.content
        if let destructionDate = notes.selfDestructionDate {
            switchDestroyDate.setOn(true, animated: true)
            datePicker.date = destructionDate
            datePicker.isHidden = false
        }
        }

           title = "Редактировать"
           let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(clickSaveButton))
           let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(clickCancelButton))
           navigationItem.rightBarButtonItem = save
           navigationItem.leftBarButtonItem = cancel
           navigationController?.navigationBar.isHidden = false
}
    
@objc public func clickCancelButton() {
       navigationController?.popViewController(animated: true)
   }
    
@objc public func clickSaveButton() {
    
     guard let n = notes else {
                print("ERROR!!!!! get note")
                return
            }
            
            var date: Date? = nil
            if switchDestroyDate.isOn {
                date = datePicker.date
            }
            
            delegate?.noteUpdated(note: Note(
                title: tfTitle.text ?? "",
                content: tvContent.text ?? "",
                importance: n.importance,
                uid: n.uid,
    color: n.color,
//                let rgba = self.cvColors.color.rgba
//                                                                         n.color = String(format: "%f,%f,%f,%f", arguments: [rgba.red, rgba.green, rgba.blue, rgba.alpha]),
                //color: currentColor ?? .white,
                selfDestructionDate: date
            ))
            
            let newNote = Note(
                 title: tfTitle.text ?? "",
                           content: tvContent.text ?? "",
                           importance: n.importance,
                           uid: n.uid,
                           //color: .white,
                color: lastSelected?.backgroundColor ?? .white,
                selfDestructionDate: switchDestroyDate.isOn ? datePicker.date : nil
            )
            saveNote(newNote)
            //navigationController?.popViewController(animated: true)
            
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
                 cnstrColorsToDatePicker.isActive = true
                 //registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(cnstrBottomToView.constant)
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        cnstrBottomToView.constant = keyboardSize.height + 20
        let distanceToBottom = self.scrollView.frame.height - cvColors.frame.origin.y - cvColors.frame.size.height
        let collapseSpace = keyboardSize.height - distanceToBottom
        if collapseSpace > 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: collapseSpace + 10)
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentOffset = .zero
        cnstrBottomToView.constant = 20
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCell
        if indexPath.row == colors.count {
            if colors.contains(notes!.color) {
                cell?.backgroundView = GradientView(frame: cell?.frame ?? .zero)
            } else {
                cell?.backgroundColor = notes!.color
                cell?.isSelected = true
                cell?.draw()
                lastSelected = cell
            }
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(openColorPicker))
            cell?.addGestureRecognizer(longPress)
            
        } else {
            cell?.backgroundColor = colors[indexPath.row]
            if notes!.color == colors[indexPath.row] {
                cell?.isSelected = true
                cell?.draw()
                lastSelected = cell
            }
        }
        return cell ?? UICollectionViewCell()
    }
    
    @objc func openColorPicker() {
        let colorPicker = ColorPickerController()
        colorPicker.onSelection = { color in
            let index = IndexPath(row: self.colors.count, section: 0)
            let cell = self.cvColors.cellForItem(at: index) as? ColorCell
            cell?.backgroundColor = color
            cell?.backgroundView = nil
            if let selected = self.cvColors.indexPathsForSelectedItems?.first {
                self.collectionView(self.cvColors, didDeselectItemAt: selected)
            }
            self.collectionView(self.cvColors, didSelectItemAt: index)
        }
        if let cell = cvColors.cellForItem(at: IndexPath(row: colors.count, section: 0)), cell.backgroundView == nil {
            colorPicker.colorSelection = cell.backgroundColor
        }
        present(colorPicker, animated: true, completion: nil)
    }
    
    var lastSelected: ColorCell?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorCell {
            if indexPath.row == colors.count, cell.backgroundView != nil {
                cell.unselect()
                lastSelected?.isSelected = true
                lastSelected?.draw()
            } else {
                lastSelected?.unselect()
                cell.draw()
                lastSelected = cell
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? ColorCell)?.unselect()
    }
    @IBAction func useDestroyDateChanged(_ sender: UISwitch) {
        datePicker.isHidden = !sender.isOn
        cnstrColorsToDatePicker.isActive = sender.isOn
    }
    // Сохраняем заметку
        private func saveNote(_ note: Note) {
            guard let nb = notebook else {
                print("ERROR get notebook")
                return
            }
            
            let backendQueue = OperationQueue()
            let dbQueue = OperationQueue()
            let commonQueue = OperationQueue()
            
            let saveNoteOperation = SaveNoteOperation(
                note: note,
                notebook: nb,
                backendQueue: backendQueue,
                dbQueue: dbQueue,
                context: context,
                backgroundContext: backgroundContext
            )
            commonQueue.addOperation(saveNoteOperation)
            
            let updateUI = BlockOperation { [weak self] in
                print("save block operation UI")
                self?.navigationController?.popViewController(animated: true)
            }
            saveNoteOperation.completionBlock = {
                print("saveNoteOperation.completionBlock")
                OperationQueue.main.addOperation(updateUI)
            }
        }
    
}


