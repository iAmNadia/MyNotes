

import Foundation
import UIKit

class GalleryDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var images = [UIImage]()
    var imageViews = [UIImageView]()
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (index, view) in imageViews.enumerated() {
            view.frame.size = scrollView.frame.size
            view.frame.origin.x = scrollView.frame.width * CGFloat(index)
            view.frame.origin.y = 0
        }
        scrollView.contentSize.width = scrollView.frame.width * CGFloat(imageViews.count)
        scrollView.contentOffset.x = scrollView.frame.width * CGFloat(currentIndex)
    }
    
}

extension GalleryDetailViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageIndex = (scrollView.contentOffset.x / scrollView.frame.width)
//        currentIndex = Int(pageIndex.rounded())
//        print(currentIndex)
//    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let pageIndex = (scrollView.contentOffset.x / scrollView.frame.width)
        currentIndex = Int(pageIndex.rounded())
    }
}
