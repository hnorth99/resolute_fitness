//
//  initViewController.swift
//  Resolute Fitness
//
//  Created by Hunter North on 7/22/18.
//  Copyright © 2018 Hunter North. All rights reserved.
//

import UIKit

class InitViewController: UIViewController {
    
    @IBOutlet weak var resoluteLabel: UILabel!
    @IBOutlet weak var fitnessLabel: UILabel!
    @IBOutlet weak var swipeUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Creates event for a down swipe gesture that leads to middle view controller
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionEntrySegue(swipe:)))
        upSwipe.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(upSwipe)
        
        //set font sizes
        setFontSizes()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setFontSizes(){
        var fontSizes : [[CGFloat]] = [[45,14], [49,17], [55,19], [90,30]]
        var phoneSize = 1
        
        //determine phone size based off of width
        if (UIScreen.main.bounds.width < 375) {
            phoneSize = 0
        } else if (UIScreen.main.bounds.width == 375){
            phoneSize = 1
        } else if ((UIScreen.main.bounds.width > 375) && (UIScreen.main.bounds.width < 450)){
            phoneSize = 2
        } else {
            phoneSize = 3
        }
        
        //adjust font sizes
        resoluteLabel.font = resoluteLabel.font.withSize(fontSizes[phoneSize][0])
        fitnessLabel.font = fitnessLabel.font.withSize(fontSizes[phoneSize][0])
        swipeUpLabel.font = swipeUpLabel.font.withSize(fontSizes[phoneSize][1])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
