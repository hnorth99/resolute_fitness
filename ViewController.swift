//
//  ViewController.swift
//  Resolute Fitness
//
//  Created by Hunter North on 7/20/18.
//  Copyright © 2018 Hunter North. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    //Top Third Outlets
    @IBOutlet weak var workoutDayName: UILabel!
    @IBOutlet weak var statusName: UILabel!
    
    //Mid Third Outlets
    @IBOutlet weak var midLogo: UIImageView!
    @IBOutlet weak var midExHolder: UIImageView!
    @IBOutlet weak var midExLabel: UILabel!
    
    //Bottom Third A Outlets
    @IBOutlet weak var bottomThirdA: UIView!
    @IBOutlet weak var beginButton: UIButton!
    
    //Bottom Third B Outlets
    @IBOutlet weak var bottomThirdB: UIView!
    @IBOutlet weak var duringWorkoutNextButton: UIButton!
    @IBOutlet weak var repOne: UILabel!
    @IBOutlet weak var repTwo: UILabel!
    @IBOutlet weak var repThree: UILabel!
    @IBOutlet weak var repFour: UILabel!
    @IBOutlet weak var repFive: UILabel!
    @IBOutlet weak var logoMarkOne: UIButton!
    @IBOutlet weak var logoMarkTwo: UIButton!
    @IBOutlet weak var logoMarkThree: UIButton!
    @IBOutlet weak var logoMarkFour: UIButton!
    @IBOutlet weak var logoMarkFive: UIButton!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    @IBOutlet weak var labelFive: UILabel!
    
    
    //Bottom Third C Outlets
    @IBOutlet weak var bottomThirdC: UIView!
    @IBOutlet weak var maxRepTextField: UITextField!
    @IBOutlet weak var passFailSwitch: UISwitch!
    @IBOutlet weak var passFailLabel: UILabel!
    @IBOutlet weak var maxRepNextButton: UIButton!
    
    //Bottom Third D Outlets
    @IBOutlet weak var bottomThirdD: UIView!
    @IBOutlet weak var nextDayUpLabel: UILabel!
    
    //Date
    var potCurrDate: Date? = nil
    var savedDateForRestDays: Date? = nil
    
    //Array of strings that label each type of workout day
    var workoutDayStrings: [String] = ["Push Day", "Pull Day", "Leg Day", "One Rep Day"]

    //Arrays that hold the status of the current exercise
    var repLabelArray: [UILabel] = []
    
    //Exercises for one rep day
    var oneRepExArray: [String] = ["Bench Press", "Deadlift", "Back Squat"]
    
    //Variables used to deal with random events
    var randomInt : Int = 0
    var randomIntRep : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Creates event for a right swipe gesture that leads to left view controller
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionFromMiddle(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
        
        //Creates event for a left swipe gesture that leads to right view controller
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionFromMiddle(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
        
        //If it is a new day
            //See if workout has been completed
                //Calc rest days
                //Reset variables for workoutComp and workoutBegan
        if (newDateTest()){
            AppDelegate.GVar.exNumber = 0
            if(AppDelegate.GVar.workoutComp == true){
                AppDelegate.GVar.workoutBegun = false
                AppDelegate.GVar.workoutComp = false
                //Next two lines bring workouts remaining down one then calculate the new workout day
                if (AppDelegate.GVar.todaysWorkout != 3){
                    AppDelegate.GVar.workoutDayRemaining[AppDelegate.GVar.todaysWorkout] = AppDelegate.GVar.workoutDayRemaining[AppDelegate.GVar.todaysWorkout] - 1
                    AppDelegate.GVar.todaysWorkout = todayIs()
                } else {
                    //Develop a new plan
                    AppDelegate.GVar.todaysWorkout = 0
                    AppDelegate.GVar.cyclesCompleted = AppDelegate.GVar.cyclesCompleted + 1
                    updateProbabilities()
                    createWorkout()
                    AppDelegate.GVar.workoutDayRemaining[0] = 5
                    AppDelegate.GVar.workoutDayRemaining[1] = 5
                    AppDelegate.GVar.workoutDayRemaining[2] = 5
                }
                //Update workouts completed
                AppDelegate.GVar.allStats[0][0] = AppDelegate.GVar.allStats[0][0] + 1
                //Add one to the consecutive amount of workouts completed
                AppDelegate.GVar.consecutiveWorkouts = AppDelegate.GVar.consecutiveWorkouts + 1
                //Check if the new number of consecutive workouts is a record
                newLongestStreak()
            } else {
                //update rest days
                let components = Calendar.current.dateComponents([.day], from: savedDateForRestDays!, to: potCurrDate!)
                let daysElapsed : Int = components.day!
                
                AppDelegate.GVar.allStats[0][1] = AppDelegate.GVar.allStats[0][1] + daysElapsed
                
                AppDelegate.GVar.workoutBegun = false
                //reset the number of workouts straight to zero
                AppDelegate.GVar.consecutiveWorkouts = 0
            }
            loadProperScreen()
        } else {
            AppDelegate.GVar.todaysWorkout = todayIs()
            loadProperScreen()
        }
        
        //set font sizes
        setFontSizes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Hide keyboard with tapping off keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Is it a new day?
    func newDateTest() -> Bool{
        //Find the date registered on hardware
        potCurrDate = Date()
        
        //If its a new day...
            //Count number of restdays
            //change the day
        if (sameDayBool()){
            //hold the old date to calc rest days
            savedDateForRestDays = AppDelegate.GVar.currDate
            //asign current date
            AppDelegate.GVar.currDate = potCurrDate
            return true
        }
        return false
    }
    
    func sameDayBool() -> Bool {
        let components = Calendar.current.dateComponents([.day], from: AppDelegate.GVar.currDate!, to: potCurrDate!)
        let daysElapsed = components.day;
        if (daysElapsed == 0){
            return false
        }
        return true
    }
    
    func findIndex(of: String, arr: [String]) -> Int {
        for x in 0...arr.count {
            if (arr[x] == of){
                return x
            }
        }
        return -1
    }
    
    
    //Figure out what todays workout is
    func todayIs() -> Int{
        //find which workout has the largest amount of repetitions remaining
        let biggestVal = AppDelegate.GVar.workoutDayRemaining.max()
        //If all have zero
            //then its one rep day
        if(biggestVal == 0){
            return 3
        }
        //Find the first index of the largest amount of remaining repitioins
        for x in 0...2 {
            if (AppDelegate.GVar.workoutDayRemaining[x] == biggestVal){
                return x
            }
        }
        //unreachable return
        return 4
    }
    
    //Creates the proper layout for the frame according to:
        //Todays workout and whether or not it has been completed
    func loadProperScreen(){
        if (!AppDelegate.GVar.workoutBegun) {
            //Bring up bottomThirdA
            hideSubviews(aBool: false, bBool: true, cBool: true, dBool: true)
            bottomThirdALoad()
        } else {
            if(AppDelegate.GVar.workoutComp){
                //Bring up bottomThirdD
                hideSubviews(aBool: true, bBool: true, cBool: true, dBool: false)
                bottomThirdDLoad()
            } else {
                if (AppDelegate.GVar.todaysWorkout == 3){
                    //Bring up bottomThirdC
                    hideSubviews(aBool: true, bBool: true, cBool: false, dBool: true)
                    bottomThirdCLoad()
                } else {
                    //Bring up bottomThirdB
                    hideSubviews(aBool: true, bBool: false, cBool: true, dBool: true)
                    bottomThirdBLoad()
                }
            }
        }
    }
    
    //function that brings up and hides different subviews to create framework of page
    func hideSubviews(aBool: Bool, bBool: Bool, cBool: Bool, dBool: Bool){
        bottomThirdA.isHidden = aBool;
        bottomThirdB.isHidden = bBool;
        bottomThirdC.isHidden = cBool;
        bottomThirdD.isHidden = dBool;
    }
    
    //Function that creates the proper text for when bottomThirdA is visible
    func bottomThirdALoad(){
        workoutDayName.text = "Today Is:"
        statusName.text = workoutNameString()
    }
    
    //Creates a string for what the name of today's workout is
    func workoutNameString() -> String{
        if(AppDelegate.GVar.todaysWorkout == 0){
            return "Push Day"
        } else if (AppDelegate.GVar.todaysWorkout == 1){
            return "Pull Day"
        } else if (AppDelegate.GVar.todaysWorkout == 2){
            return "Leg Day"
        } else {
            return "One Rep Day"
        }
    }
    
    //Function that creates the proper text for when bottomThirdB is visible
    func bottomThirdBLoad(){
        //Set titles of page
        workoutDayName.text = workoutNameString()
        statusName.text = "Workout"
        
        //Adjust middle part (circle with exercise name) of frame
        midLogo.isHidden = true
        midExHolder.isHidden = false
        midExLabel.isHidden = false
        
        //Fill midExLabel with correct exercise
        midExLabel.text = AppDelegate.GVar.currEx[AppDelegate.GVar.todaysWorkout][AppDelegate.GVar.exNumber]
        
        //Fill repLabels with correct number of reps
        fillRepLabelText()
    }
    
    //Populates all repLabels with the correct int
    //value stored within AppDelegate.GVar.currRep is a single int that correspons to a rep range
        //0 = low
        //1 = mid
        //2 = high
    func fillRepLabelText(){
        repLabelArray = [repOne, repTwo,repThree, repFour, repFive]
        let lowRepRange : [Int] = [6,3,3,3,6]
        let midRepRange : [Int] = [10,8,5,5,8]
        let highRepRange : [Int] = [12,10,8,6,8]
        var choosenRepRange : [Int] = []
        
        //determine what the choosenRepRange is
        if (AppDelegate.GVar.currRep[AppDelegate.GVar.todaysWorkout][AppDelegate.GVar.exNumber] == 0){
            choosenRepRange = lowRepRange
        } else if (AppDelegate.GVar.currRep[AppDelegate.GVar.todaysWorkout][AppDelegate.GVar.exNumber] == 1){
            choosenRepRange = midRepRange
        } else {
            choosenRepRange = highRepRange
        }
        
        //populate each label
        for x in 0...4{
            repLabelArray[x].text = String(choosenRepRange[x])
        }
    }
    
    //Action when marker for when set one is pressed
    @IBAction func markerOne(_ sender: Any) {
        toggleExProgress(number: 0)
        toggleLogo(number: 0)
    }
    
    //Action when marker for when set two is pressed
    @IBAction func markerTwo(_ sender: Any) {
        toggleExProgress(number: 1)
        toggleLogo(number: 1)
    }
    
    //Action when marker for when set three is pressed
    @IBAction func markerThree(_ sender: Any) {
        toggleExProgress(number: 2)
        toggleLogo(number: 2)
    }
    
    //Action when marker for when set four is pressed
    @IBAction func markerFour(_ sender: Any) {
        toggleExProgress(number: 3)
        toggleLogo(number: 3)
    }
    
    //Action when marker for when set five is pressed
    @IBAction func markerFive(_ sender: Any) {
        toggleExProgress(number: 4)
        toggleLogo(number: 4)
    }
    
    //flips the state of the boolean from exProgress array
    func toggleExProgress(number : Int){
        if (AppDelegate.GVar.exProgress[number]) {
            AppDelegate.GVar.exProgress[number] = false
        } else {
            AppDelegate.GVar.exProgress[number] = true
        }
    }
    
    //function called each time one of the sets is pushed
    //toggles the logo to visible so the set appears completed
    func toggleLogo(number : Int) {
        let logoArray : [UIButton] = [logoMarkOne, logoMarkTwo, logoMarkThree, logoMarkFour, logoMarkFive]
        let repNumArray : [UILabel] = [repOne, repTwo, repThree, repFour, repFive]
        let repsLabelArray : [UILabel] = [labelOne, labelTwo, labelThree, labelFour, labelFive]
        
        if (AppDelegate.GVar.exProgress[number]){
            logoArray[number].setImage(UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal), for: .normal)
            repNumArray[number].isHidden = true
            repsLabelArray[number].isHidden = true
        } else {
            logoArray[number].setImage(UIImage(named: "transparent")?.withRenderingMode(.alwaysOriginal), for: .normal)
            repNumArray[number].isHidden = false
            repsLabelArray[number].isHidden = false
        }
    }
    
    //Button that transitions the workout to the next exercise
    @IBAction func nextExercise(_ sender: Any) {
        let logoArray : [UIButton] = [logoMarkOne, logoMarkTwo, logoMarkThree, logoMarkFour, logoMarkFive]
        let repNumArray : [UILabel] = [repOne, repTwo, repThree, repFour, repFive]
        let repsLabelArray : [UILabel] = [labelOne, labelTwo, labelThree, labelFour, labelFive]
        
        if(allSetsComp()){
            //Make sure its not already the last exercise
            if(AppDelegate.GVar.exNumber != 4){
                //Move to next exercise number
                AppDelegate.GVar.exNumber = AppDelegate.GVar.exNumber + 1
                
                //Reset set boxes
                for x in 0...4 {
                    logoArray[x].setImage(UIImage(named: "transparent")?.withRenderingMode(.alwaysOriginal), for: .normal)
                    repNumArray[x].isHidden = false
                    repsLabelArray[x].isHidden = false
                    AppDelegate.GVar.exProgress[x] = false
                }
                
                //Fill midExLabel with correct exercise
                midExLabel.text = AppDelegate.GVar.currEx[AppDelegate.GVar.todaysWorkout][AppDelegate.GVar.exNumber]
                //Fill rep label values
                fillRepLabelText()
            } else {
                AppDelegate.GVar.workoutComp = true
                loadProperScreen()
            }
        } else {
            //Sends out an elert to complete all sets before continuing
            let alertController = UIAlertController(title: "Finish all sets before moving on to the next exercise.", message: "Tapping on the set marks it as complete.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func allSetsComp() -> Bool{
        for x in AppDelegate.GVar.exProgress{
            if(!x){
                return false
            }
        }
        return true
    }
    
    //Function that creates the proper text for when bottomThirdC is visible
    func bottomThirdCLoad(){
        
        //Set titles of page
        workoutDayName.text = workoutNameString()
        statusName.text = "Workout"
        
        //Adjust middle part (circle with exercise name) of frame
        midLogo.isHidden = true
        midExHolder.isHidden = false
        midExLabel.isHidden = false
        
        midExLabel.text = oneRepExArray[AppDelegate.GVar.exNumber]
    }
    
    //Function that creates the proper text for when bottomThirdD is visible
    func bottomThirdDLoad(){
        workoutDayName.text = workoutNameString()
        statusName.text = "Completed"
        nextDayUpLabel.text = nextWorkoutNameString()
        
        //Adjust middle part (circle with exercise name) of frame
        midLogo.isHidden = false
        midExHolder.isHidden = true
        midExLabel.isHidden = true
    }
    
    @IBAction func passFailSwitch(_ sender: Any) {
        if(passFailSwitch.isOn){
            passFailLabel.text = "Pass"
        } else {
            passFailLabel.text = "Fail"
        }
    }
    
    @IBAction func oneRepNextExercise(_ sender: Any) {
        //Creation of alert that confirms the user wants to continue
        let alertA = UIAlertController(title: "Are you sure you want to continue?", message: "You will not be able to change the statistics you have just entered.", preferredStyle: UIAlertController.Style.alert)
    
        //Creation of alert that reminds user to enter a weight
        let alertB = UIAlertController(title: "You forgot to enter the amount of weight you are attempting for your one-rep-max.", message: "Please go back and update the input for this value.", preferredStyle: UIAlertController.Style.alert)
        
        let alertC = UIAlertController(title: "Too much weight", message: "Weight may not exceed 999 pounds", preferredStyle: UIAlertController.Style.alert)
        
        //Create a variable that stores the users attempted rep in the form of an Int
        let attemptedWeight: Int? = Int(maxRepTextField.text!)
        
        //Adding two options to alertA
        //When user does not want to continue
        alertA.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            alertA.dismiss(animated: true, completion: nil)
        }))
        //When user wants to continue
        alertA.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { (action) in
            alertA.dismiss(animated: true, completion: nil)
            
            //NEW CURRENT ONE REP
            if(self.passFailSwitch.isOn){
                AppDelegate.GVar.allStats[AppDelegate.GVar.exNumber + 1][0] = attemptedWeight!
            }
            
            //NEW BEST ONE REP
            //if the user completed the lift and the lift is the heaviest one yet
                //then update stat array and note that this workout caused improvment
            if(self.passFailSwitch.isOn && (attemptedWeight! > AppDelegate.GVar.allStats[AppDelegate.GVar.exNumber + 1][1])){
                //New best one rep
                AppDelegate.GVar.allStats[AppDelegate.GVar.exNumber + 1][1] = attemptedWeight!
                //Add one to the number of successful routines
                AppDelegate.GVar.allStats[0][3] = AppDelegate.GVar.allStats[0][3] + 1
                //Set workout as a success
                AppDelegate.GVar.passFailBoolArray[AppDelegate.GVar.exNumber] = true
            }
            
            //Update the exercise number, and if the workout is completed then load the completion screen
            if(AppDelegate.GVar.exNumber != 2){
                AppDelegate.GVar.exNumber = AppDelegate.GVar.exNumber + 1
            } else {
                AppDelegate.GVar.workoutComp = true
                self.loadProperScreen()
            }
            
            //Update frame to show the next exercise
            self.midExLabel.text = self.oneRepExArray[AppDelegate.GVar.exNumber]
            self.passFailSwitch.isOn = false
            self.passFailLabel.text = "Fail"
            self.maxRepTextField.text = ""
            
            //NEW GAINS PER WORKOUT
            if(AppDelegate.GVar.cyclesCompleted != 0){
                AppDelegate.GVar.allStats[AppDelegate.GVar.exNumber + 1][3] = (AppDelegate.GVar.allStats[AppDelegate.GVar.exNumber + 1][0] - AppDelegate.GVar.allStats[AppDelegate.GVar.exNumber + 1][2]) / AppDelegate.GVar.cyclesCompleted
            }
        }))
        
        //Adding an option to alertB
        //So a user can exit the alert
        alertB.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            alertB.dismiss(animated: true, completion: nil)
        }))
        
        //Adding an option to alertC
        //So a user can exit the alert
        alertC.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            alertC.dismiss(animated: true, completion: nil)
        }))
        
        //Make sure that the text field is not empty
        if (maxRepTextField.text == ""){
            self.present(alertB, animated: true, completion: nil)
        }
        
        //Make sure the user inputed a value less than 1000
        if (!lessThanFourChar(weight: attemptedWeight!)){
            self.present(alertC, animated: true, completion: nil)
        }
        
        //If the value in the text field is empty remind the user with alertB otherwise make sure the user wants to continue with alertB
        if (attemptedWeight == 0){
            self.present(alertB, animated: true, completion: nil)
        } else {
            self.present(alertA, animated: true, completion: nil)
        }
    }
    
    //Creates a string for what the name of tomorrows workout is
    func nextWorkoutNameString() -> String{
        if(AppDelegate.GVar.todaysWorkout == 0){
            return "Pull Day"
        } else if (AppDelegate.GVar.todaysWorkout == 1){
            return "Leg Day"
        } else if (AppDelegate.GVar.todaysWorkout == 2){
            if(AppDelegate.GVar.workoutDayRemaining[0] == 0){
                return "One Rep Day"
            } else {
                return "Chest Day"
            }
        } else {
            return "Chest Day"
        }
    }
    
    @IBAction func beginButtonPushed(_ sender: Any) {
        AppDelegate.GVar.workoutBegun = true
        loadProperScreen()
    }
    
    //function changing the value of randomInt to a new random integer
    func randInt(max: Int){
        randomInt = Int(arc4random_uniform(UInt32(max)))
    }
    
    //returns a random double between 0 and 1
    func randDouble() -> Double{
        return drand48()
    }
    
    //creates a new set of workouts for the user
    func createWorkout(){
        for x in 0...2 {
            //clear current exercise
            if (AppDelegate.GVar.currEx[x].count != 0) {
                AppDelegate.GVar.currEx[x].removeAll()
            }
            //clear current reps
            if (AppDelegate.GVar.currRep[x].count != 0){
                AppDelegate.GVar.currRep[x].removeAll()
            }
        }
        
        for x in 0...2 {
            for y in 0...4{
                //first exercise is always the same: main exercise (bench press, deadlift, backsquat)
                if (y == 0){
                    AppDelegate.GVar.currEx[x].append(AppDelegate.GVar.totEx[x][0])
                    addRep(index: x)
                } else {
                    //funciton that searches for a random exerise
                    lookForNewExercise(index: x)
                }
            }
        }
        
        orderWorkout()
    }
    
    func lookForNewExercise(index: Int){
        randInt(max: AppDelegate.GVar.totEx[index].count)
        //if the new workout plan doesnt already contain the random selected one and then passes the probability test function then it is addded to the current workout and a random rep range is generated with it
        if (AppDelegate.GVar.currEx[index].contains(AppDelegate.GVar.totEx[index][randomInt]) || !passesProbTest(ex: AppDelegate.GVar.totEx[index][randomInt], index: index, exercise: randomInt) ){
            lookForNewExercise(index: index)
        } else {
            AppDelegate.GVar.currEx[index].append(AppDelegate.GVar.totEx[index][randomInt])
            addRep(index: index)
        }
    }
    
    //Probablity test generates a random double...
    //If the random double is less than the corressponding double stored in the proability array then it passes the probTest
    func passesProbTest(ex: String, index: Int, exercise: Int) -> Bool {
        if(randDouble() < AppDelegate.GVar.probEx[index][exercise]){
            return true;
        }
        return false
    }
    
    //function that adds a random rep range to workout
    func addRep(index: Int){
        //generates a random int
        randomIntRep = Int(arc4random_uniform(UInt32(3)))
        //if statement below is another proability test
        //if passed then added to corresponding rep within current workout
        //if it doesn't pass, generate a new rep by recalling function
        if (randDouble() < AppDelegate.GVar.probRep[index][randomIntRep]){
            AppDelegate.GVar.currRep[index].append(AppDelegate.GVar.totRep[index][randomIntRep])
        } else {
            addRep(index: index)
        }
    }
    
    //function that orders the array holding the current workout so that exercises are done/displayed in an order that follows exerise rule of ordering exercises from largest muscle group to smallest
    //Sorted with bubblesort
    func orderWorkout(){
        for x in 0...2{
            for _ in 0...AppDelegate.GVar.currEx[x].count {
                for value in 1...AppDelegate.GVar.currEx[x].count - 1 {
                    if (findIndex(of: AppDelegate.GVar.currEx[x][value - 1], arr: AppDelegate.GVar.totEx[x]) > findIndex(of: AppDelegate.GVar.currEx[x][value], arr: AppDelegate.GVar.totEx[x])) {
                        let largerValue = AppDelegate.GVar.currEx[x][value-1]
                        AppDelegate.GVar.currEx[x][value-1] = AppDelegate.GVar.currEx[x][value]
                        AppDelegate.GVar.currEx[x][value] = largerValue
                    }
                }
            }
        }
    }
    
    //Updates the probabilities corresponding to exercises and reps if users lifts improved
    func updateProbabilities(){
        for x in 0...2{
            if(AppDelegate.GVar.passFailBoolArray[x]){
                AppDelegate.GVar.allStats[0][3] = AppDelegate.GVar.allStats[0][3] + 1
                for y in 1...4{
                    let targetIndexExercise : Int = findIndex(of: AppDelegate.GVar.currEx[x][y], arr: AppDelegate.GVar.totEx[x])
                    let targetIndexRep : Int = AppDelegate.GVar.currRep[x][y]
                    AppDelegate.GVar.probEx[x][targetIndexExercise] = AppDelegate.GVar.probEx[x][targetIndexExercise] + 0.08
                    AppDelegate.GVar.probRep[x][targetIndexRep] = AppDelegate.GVar.probRep[x][targetIndexRep] + 0.03
                }
            }
        }
    }
    
    func newLongestStreak(){
        if(AppDelegate.GVar.consecutiveWorkouts > AppDelegate.GVar.allStats[0][2]){
            AppDelegate.GVar.allStats[0][2] = AppDelegate.GVar.consecutiveWorkouts
        }
    }
    
    func setFontSizes(){
        var fontSizes : [[CGFloat]] = [[54,49,33], [60,53,38], [70,59,44], [120,106,72]]
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
        
        //adjust font sizes to device
        workoutDayName.font = workoutDayName.font.withSize(fontSizes[phoneSize][0])
        statusName.font = statusName.font.withSize(fontSizes[phoneSize][1])
        midExLabel.font = midExLabel.font.withSize(fontSizes[phoneSize][2])
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
    
    
    @IBAction func instructionsButtonPushed(_ sender: Any) {
        performSegue(withIdentifier: "mainVCToInstructions", sender: self)
    }
}



extension UIViewController {
    //View controller extension that is used on the middle view controller that performs segues to left and right view controllers
    @objc func swipeActionFromMiddle(swipe: UISwipeGestureRecognizer){
        //switch statement checks if the swipe is a right (val: 1) or left (val: 2) swipe
        switch swipe.direction.rawValue {
        case 1:
            performSegue(withIdentifier: "SwipeRightFromMiddle", sender: self)
        case 2:
            performSegue(withIdentifier: "SwipeLeftFromMiddle", sender: self)
        default:
            break
        }
    }
    
    //View controller extension that is used on the left view controller that performs segues to the middle view controller
    @objc func swipeActionFromLeft(swipe:UISwipeGestureRecognizer){
        performSegue(withIdentifier: "SwipeLeftFromLeft", sender: self)
    }
    
    //View controller extension that is used on the right view controller that performs segues to the middle view controller
    @objc func swipeActionFromRight(swipe:UISwipeGestureRecognizer){
        performSegue(withIdentifier: "SwipeRightFromRight", sender: self)
    }
    
    //View controller extension that is used on the initial view controller that performs segue to the middle view controller
    @objc func swipeActionEntrySegue(swipe:UISwipeGestureRecognizer){
        if(AppDelegate.GVar.initStatsEntered){
            performSegue(withIdentifier: "EntrySegue", sender: self)
        } else {
            performSegue(withIdentifier: "EntrySegueToBegStatsVC", sender: self)
        }
    }
    
}

extension String {
    //function that returns a string that is a substring of two index points within a larger string
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}

