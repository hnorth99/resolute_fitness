//
//  InstructionsViewController.swift
//  Resolute Fitness
//
//  Created by Hunter North on 9/12/18.
//  Copyright © 2018 Hunter North. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var overViewTitle: UILabel!
    @IBOutlet weak var workoutPageTitle: UILabel!
    @IBOutlet weak var planPageTitle: UILabel!
    @IBOutlet weak var statisticsPageTitle: UILabel!
    var titles : [UILabel] = []
    
    @IBOutlet weak var overviewText: UITextView!
    @IBOutlet weak var workoutPageText: UITextView!
    @IBOutlet weak var planPageText: UITextView!
    @IBOutlet weak var statisticsPageText: UITextView!
    var text : [UITextView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set font sizes
        setFontSizes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueButtonPushed(_ sender: Any) {
        performSegue(withIdentifier: "InstructionsToMain", sender: self)
    }
    
    func setFontSizes(){
        var fontSizes : [CGFloat] = [50,57,63,80]
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
        
        if (phoneSize == 3) {
            titles.append(overViewTitle)
            titles.append(workoutPageTitle)
            titles.append(planPageTitle)
            titles.append(statisticsPageTitle)
            text.append(overviewText)
            text.append(workoutPageText)
            text.append(planPageText)
            text.append(statisticsPageText)
            
            for x in 0...3{
                titles[x].font = titles[x].font.withSize(60)
                text[x].font = text[x].font?.withSize(22)
            }
        }
        
        //adjust font size of title
        titleLabel.font = titleLabel.font.withSize(fontSizes[phoneSize])
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
