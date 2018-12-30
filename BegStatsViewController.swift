//
//  BegStatsViewController.swift
//  Resolute Fitness
//
//  Created by Hunter North on 9/12/18.
//  Copyright © 2018 Hunter North. All rights reserved.
//

import UIKit

class BegStatsViewController: UIViewController, UITextFieldDelegate {
    //Outlet for textView
    @IBOutlet weak var BegStatsText: UITextView!
    
    //Outlets for each text field
    @IBOutlet weak var benchTextField: UITextField!
    @IBOutlet weak var deadliftTextView: UITextField!
    @IBOutlet weak var backSquatTextView: UITextField!
    var textFieldArray : [UITextField] = []
    
    //Outlets for each label
    @IBOutlet weak var benchLabel: UILabel!
    @IBOutlet weak var deadliftLabel: UILabel!
    @IBOutlet weak var backSquatLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set font sizes
        setFontSizes()
        
        //Make text view uneditable and unscrollable
        BegStatsText.isEditable = false
        BegStatsText.isScrollEnabled = false
        
        // Do any additional setup after loading the view.
        //fill text field array
        fillTextFieldArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillTextFieldArray(){
        textFieldArray.append(benchTextField)
        textFieldArray.append(deadliftTextView)
        textFieldArray.append(backSquatTextView)
    }
    
    //when continue button is pushed, check that all fields are filled and not equal to 0
    //then add them to stats array
    //then continue to app
    @IBAction func continueButtonPushed(_ sender: Any) {
        //If there are empty fields or zeros
        if(!checkAllTextFieldsFilled() || !checkForZero()){
            //create alert telling user to fix problem
            let alertController = UIAlertController(title: nil, message: "Make sure to fill in each text field with values greater than zero.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
        } else if (!noFourCharValues()){
            let alertTooMuchWeight = UIAlertController(title: "Too much weight", message: "Weight may not exceed 999 pounds", preferredStyle: UIAlertController.Style.alert)
            //Adding an option to alertC
            //So a user can exit the alert
            alertTooMuchWeight.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                alertTooMuchWeight.dismiss(animated: true, completion: nil)
            }))
            self.present(alertTooMuchWeight,animated: true, completion: nil)
        }else {
            //crete alert telling user the stats they have inputed will not be editable again
            let alertController = UIAlertController(title: "Are you sure you want to continue?", message: "You will not be able to change the statistics you have just entered.", preferredStyle: UIAlertController.Style.alert)
            //Dont continue
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {(action) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            //Continue
            //add stats to allstats array
            //head to main screen
            alertController.addAction(UIAlertAction(title: "Continue", style:
                //adding stats to stat array
                UIAlertAction.Style.default, handler: {(action) in
                for x in 0...2{
                    for y in 0...2 {
                        AppDelegate.GVar.allStats[x + 1][y] = Int(self.textFieldArray[x].text!)!
                    }
                }
                alertController.dismiss(animated: true, completion: nil)
                //Update boolean so that init stats have been entered
                AppDelegate.GVar.initStatsEntered = true
                //segue to main screen
                self.performSegue(withIdentifier: "BegStatsVCToInstructions", sender: self)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //function that checks all text boxes are filled
    //returns boolean
    func checkAllTextFieldsFilled() -> Bool {
        for x in textFieldArray {
            if (x.text == ""){
                return false
            }
        }
        return true
    }
    
    //function that checks not text boxes equal 0
    //returns boolean
    func checkForZero() -> Bool {
        for x in textFieldArray{
            if (Int(x.text!)! == 0) {
                return false
            }
        }
        return true
    }
    
    //Hide keyboard with tapping off keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setFontSizes(){
        var fontSizes : [[CGFloat]] = [[16,18], [18,21], [22,25], [38,48]]
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
        BegStatsText.font = BegStatsText.font?.withSize(fontSizes[phoneSize][0])
        
        //create array for labels than edit their font sizes
        let labelArray = [benchLabel, deadliftLabel,backSquatLabel]
        for x in labelArray {
            x?.font = x?.font.withSize(fontSizes[phoneSize][1])
        }
    }
    
    func noFourCharValues() -> Bool{
        for x in textFieldArray {
            if (!lessThanFourChar(weight: Int(x.text!)!)){
                return false
            }
        }
        return true
    }
    
    func lessThanFourChar(weight: Int) -> Bool {
        var weightVar = weight
        for _ in 0...3{
            if(weightVar != 0){
                weightVar = weightVar / 10
            } else {
                return true
            }
        }
        return false
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
