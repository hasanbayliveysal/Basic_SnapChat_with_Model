//
//  DetailsViewController.swift
//  SnapChat
//
//  Created by Veysal on 16.10.22.
//

import UIKit
import ImageSlideshow
import ImageSlideshowKingfisher

class DetailsViewController: UIViewController {

    @IBOutlet weak var timeLeftLabel: UILabel!
    
    
    var selectedSnap : SnapsModel?
    var imagesArray = [KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let snap = selectedSnap {
            if let time = snap.timeDifference {
                timeLeftLabel.text = "Time left: \(time)"
            }
            for image in snap.userSnaps {
                imagesArray.append(KingfisherSource(urlString: image)!)
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: Int(self.view.frame.width * 0.95), height: Int(self.view.frame.height * 0.9)))
            imageSlideShow.backgroundColor = UIColor.red
            
            // Page Indicator
            let indicator = UIPageControl()
            indicator.currentPageIndicatorTintColor = UIColor.lightGray
            indicator.pageIndicatorTintColor = UIColor.black
            //
            imageSlideShow.pageIndicator = indicator
            imageSlideShow.contentScaleMode = .scaleAspectFit
            imageSlideShow.setImageInputs(imagesArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLeftLabel)
        }
        
        
    }
    
}
