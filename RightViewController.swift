//
//  RightViewController.swift
//  Resolute Fitness
//
//  Created by Hunter North on 7/20/18.
//  Copyright © 2018 Hunter North. All rights reserved.
//

import UIKit

class RightViewController: UIViewController {
    //Outlets
    @IBOutlet weak var rightVCTitle: UILabel!
    @IBOutlet weak var rightVCSegView: UISegmentedControl!
    
    //Array that holds all the different labels for each page
    let statLabels : [[String]] = [["Workouts Completed", "Rest       Days", "Longest Streak", "Successful Routines"],
                                   ["Current Benchpress", "Best Benchpress", "Initial Benchpress", "Gains per Workout"],
                                   ["Current Deadlift", "Best   Deadlift", "Initial Deadlift", "Gains per Workout"],
                                   ["Current Backsquat", "Best Backsquat", "Initial Backsquat", "Gains per Workout"]]
    
    //Label Outlets that are filled with stat
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    var statLabelArray: [UILabel] = []
    
    //Text view outlets that label each stat
    @IBOutlet weak var textViewOne: UITextView!
    @IBOutlet weak var textViewTwo: UITextView!
    @IBOutlet weak var textViewThree: UITextView!
    @IBOutlet weak var textViewFour: UITextView!
    var textViewArray: [UITextView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creates event for a right swipe gesture that leads to middle view controller
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionFromRight(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
        
        //Fill statLabel array
        fillStatLabelArray()
        
        //Fill text view array
        fillTextViewArray()
        
        //set font sizes
        setFontSizes()
        
        //set background of textViews to clear
        textViewsStyle()
        
        //Show overallStats
        showOverallStats()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showOverallStats(){
        rightVCSegView.selectedSegmentIndex = 0
        for x in 0...3{
            statLabelArray[x].text = String(AppDelegate.GVar.allStats[0][x])
        }
    }
    
    //fills statLabelArray
    func fillStatLabelArray(){
        statLabelArray.append(labelOne)
        statLabelArray.append(labelTwo)
        statLabelArray.append(labelThree)
        statLabelArray.append(labelFour)
    }
    
    //Array that fills the text view array with different textViews
    func fillTextViewArray(){
        textViewArray.append(textViewOne)
        textViewArray.append(textViewTwo)
        textViewArray.append(textViewThree)
        textViewArray.append(textViewFour)
    }
    
    //Style text views
    func textViewsStyle(){
        for x in textViewArray {
            x.backgroundColor = UIColor.clear
            x.isScrollEnabled = false
            x.isEditable = false
        }
    }

    @IBAction func statsSegViewChanged(_ sender: Any) {
        switch rightVCSegView.selectedSegmentIndex {
        case 0:
            updateFrame(index: 0)
        case 1:
            updateFrame(index: 1)
        case 2:
            updateFrame(index: 2)
        case 3:
            updateFrame(index: 3)
        default:
            break
        }
    }
    
    //Function that fills the labels with correct exercises
    func updateFrame(index: Int){
        for x in 0...3 {
            statLabelArray[x].text = String(AppDelegate.GVar.allStats[index][x])
            textViewArray[x].text = statLabels[index][x]
        }
    }
    
    func setFontSizes(){
        var fontSizes : [[CGFloat]] = [[54,67,21], [57,75,25], [65,93,25], [110,170,53]]
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
        rightVCTitle.font = rightVCTitle.font.withSize(fontSizes[phoneSize][0])
        for x in 0...3 {
            statLabelArray[x].font = statLabelArray[x].font.withSize(fontSizes[phoneSize][1])
            textViewArray[x].font = textViewArray[x].font?.withSize(fontSizes[phoneSize][2])
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
