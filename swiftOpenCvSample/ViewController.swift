//
//  ViewController.swift
//  swiftOpenCvSample
//
//  Created by neno naninu on 2018/05/24.
//  Copyright © 2018年 neno naninu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let openCV = opencvWarapper()
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //_ = SimpestAVFoundation(view: self.mainView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func toGray(_ sender: Any) {
        let grayImg:UIImage!
        grayImg = openCV.toGray(image.image);
        image.image = grayImg;
        
    }
    
    
}

