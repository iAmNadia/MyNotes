

import Foundation
import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [UIImage]()
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        images.append(UIImage(named: "_1")!)
        images.append(UIImage(named: "_2")!)
        images.append(UIImage(named: "_3")!)
        images.append(UIImage(named: "_4")!)
        images.append(UIImage(named: "_5")!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowImage" {
            if let controller = segue.destination as? GalleryDetailViewController {
                if let index = sender as? Int {
                    controller.currentIndex = index
                }
                controller.images = images
                controller.hidesBottomBarWhenPushed = true
            }
        }
    }
    
    @objc func addImage() {
        present(imagePicker, animated: true)
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryViewCell
        
        cell.imageView.image = images[indexPath.row]
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowImage", sender: indexPath.row)
    }
}

extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            images.append(pickedImage)
            collectionView.insertItems(at: [IndexPath(item: images.count - 1, section: 0)])
        }
        dismiss(animated: true, completion: nil)
    }
}
