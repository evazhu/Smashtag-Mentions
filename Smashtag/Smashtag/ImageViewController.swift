//
//  ViewController.swift
//  Cassini
//
//  Created by 朱梦媛 on 16/5/19.
//  Copyright © 2016年 朱梦媛. All rights reserved.
//

import UIKit


class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imageURL : NSURL? {
        didSet{
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }

    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                let contentOfURL = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    [weak weakSelf = self] in
                    if url == weakSelf?.imageURL {
                        if let imageData = contentOfURL {
                            weakSelf?.image = UIImage(data: imageData)
                        } else {
                            weakSelf?.spinner.stopAnimating()
                        }
                    } else {
                        print("ignored data returned from url \(url)")
                    }
                }
            }
        }
    }

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    private var imageView = UIImageView()
    
    var image : UIImage? {
        get{
            return imageView.image
        }
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            updateZoomScaleForSize(view.bounds.size)
            spinner?.stopAnimating()
            
            
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return imageView
    }
    
    private func updateZoomScaleForSize(size: CGSize)
    {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView?.zoomScale = minScale
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollView?.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

