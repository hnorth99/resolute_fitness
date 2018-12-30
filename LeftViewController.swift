//
//  LeftViewController.swift
//  Resolute Fitness
//
//  Created by Hunter North on 7/20/18.
//  Copyright © 2018 Hunter North. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {
    //Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //Labels that are filled with exercsie
    @IBOutlet weak var exOne: UILabel!
    @IBOutlet weak var exTwo: UILabel!
    @IBOutlet weak var exThree: UILabel!
    @IBOutlet weak var exFour: UILabel!
    @IBOutlet weak var exFive: UILabel!
    
    @IBOutlet weak var panelSize: UILabel!
    
    //label that shows remaining number of workouts
    @IBOutlet weak var workoutRemainingLabel: UILabel!
    
    var exHolder : [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creates event for a left swipe gesture that leads to middle view controller
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionFromLeft(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
        
        //fill exHolder array with each exercise label
        fillExHolder()
        
        //Update the labels with correct exercise names
        updateLabels(index: 0)
        
        //Update workout remaining label
        workoutRemainingLabel.text = String(AppDelegate.GVar.workoutDayRemaining[0]) + " Workouts Remaining"
                
        //resize fonts
        setFontSizes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //func that fills exHolder array with labels that display the workout exercises
    func fillExHolder(){
        exHolder.append(exOne)
        exHolder.append(exTwo)
        exHolder.append(exThree)
        exHolder.append(exFour)
        exHolder.append(exFive)
    }
    
    //Function that fills the labels with correct exercises
    func updateLabels(index: Int){
        for x in 0...4 {
            exHolder[x].text = AppDelegate.GVar.currEx[index][x]
        }
    }
    
    //Switch statement that adjusts the labels on the page to match the selected segmented view tab
    @IBAction func segViewChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            updateLabels(index: 0)
            workoutRemainingLabel.text = String(AppDelegate.GVar.workoutDayRemaining[0]) + " Workouts Remaining"
        case 1:
            updateLabels(index: 1)
            workoutRemainingLabel.text = String(AppDelegate.GVar.workoutDayRemaining[1]) + " Workouts Remaining"
        case 2:
            updateLabels(index: 2)
            workoutRemainingLabel.text = String(AppDelegate.GVar.workoutDayRemaining[2]) + " Workouts Remaining"
        default:
            break
        }
    }
    
    //resize fonts based on iphone size
    func setFontSizes(){
        var fontSizes : [[CGFloat]] = [[54,18,26], [57,22,29], [65,25,31], [110,46,60]]
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
        
        //set each label to correct font size
        titleLabel.font = titleLabel.font.withSize(fontSizes[phoneSize][0])
        workoutRemainingLabel.font = workoutRemainingLabel.font.withSize(fontSizes[phoneSize][2])
        for x in exHolder{
            x.font = x.font.withSize(fontSizes[phoneSize][1])
        }
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
