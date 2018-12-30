//
//  AppDelegate.swift
//  Resolute Fitness
//
//  Created by Hunter North on 7/20/18.
//  Copyright © 2018 Hunter North. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //Variables used to deal with random events
    var randomInt : Int = 0
    var randomIntRep : Int = 0
    
    //struct variables are updated throughout all classes and are accessible in all other classes
    struct GVar {
        //All Possible exercises
        static var totEx: [[String]] = [["Bench Press", "Incline Bench Press", "Decline Bench Press", "Dumbbell Bench Press", "Incline Dumbell Bench Press", "Dumbbell Pullover", "Dumbbell Flies", "Incline Dumbbell Flies", "Cable Flies", "Skull Crushers", "Dips", "Overhead Dumbbell Extension", "Tricep Cable Extension"],
            ["Deadlift", "Deficit Deadlift", "Snatch Grip Deadlift", "Speed Deadlift", "Hex Bar Deadlift", "Lat Pulldown", "Bent Over Dumbell Row", "Cable Row", "T-Bar Row", "Wide Grip Pullups", "Reversed Grip Pullups", "Barbell Bicep Curls", "Dumbbell Bicep Curls", "Preacher Curls", "Cable Curls"],
            ["Back Squat", "Pause Squat", "Box Squat", "Split Squat", "Leg Press", "Hack Squat", "Weighted Lunge", "Leg Extension", "Leg Curl", "Calf Press", "Heel Raise"]]
        //All possible reps
        static var totRep: [[Int]] = [[0,1,2], [0,1,2], [0,1,2]]
        
        //Arrays that hold information of current workout
        static var currEx : [[String]] = [[],[],[]]
        static var currRep: [[Int]] = [[],[],[]]
        
        static var repHigh: [Int] = [12, 10, 8, 6, 10]
        static var repMedium: [Int] = [10, 6, 5, 4, 6]
        static var repLow: [Int] = [8, 6, 4, 2, 4]
        
        //arrays that hold probabilities for each event
        static var probEx: [[Double]] = [[],[],[]]
        static var probRep: [[Double]] = [[0.2,0.2,0.2],[0.2,0.2,0.2],[0.2,0.2,0.2]]
        
        //array that keeps record of how many workouts have been completed
        static var workoutDayRemaining: [Int] = [5,5,5]
        
        //What type of workout is today?
        //0: Push
        //1: Pull
        //2: Legs
        //3: One Rep
        static var todaysWorkout: Int = 5
        
        //string that holds the most recent date
        static var currDate: Date? = nil
        
        //array that holds the stats of each label on overviewStats page
        static var allStats : [[Int]] = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
        static var consecutiveWorkouts : Int = 0
        
        //Variables that track the status of todays workout
        static var workoutBegun: Bool = false
        static var workoutComp: Bool = false
        static var exNumber: Int = 0
        static var exProgress: [Bool] = [false, false, false, false, false]
        
        //array to manage what exercises improved during the workout
        static var passFailBoolArray: [Bool] = [false, false, false]
        
        //Count of how many workout cycles have been completed
        static var cyclesCompleted : Int = 0
        
        //Boolean to keep track of whether or not user has entered inital stats
        static var initStatsEntered : Bool = false
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //restore the variable for if the user has entered stats
        GVar.initStatsEntered = UserDefaults.standard.bool(forKey: "initStatsEntered")
        
        //If the app hasnt been run before then initialize a workout
            //Otherwise reload all the old data
        if (!GVar.initStatsEntered) {
            //fill probability arrays
            fillProbEx()
            
            //create a workout
            createWorkout()

            //set value of currDate
            setCurrDate()
        } else {
            restoreVariablesFromUserDefaults()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        loadVariablesToUserDefaults()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        loadVariablesToUserDefaults()
    }

    //Load variables to user defaults
    func loadVariablesToUserDefaults(){
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UserDefaults.standard.set(GVar.initStatsEntered, forKey: "initStatsEntered")
        UserDefaults.standard.set(GVar.currEx, forKey: "currEx")
        UserDefaults.standard.set(GVar.currRep, forKey: "currRep")
        UserDefaults.standard.set(GVar.probEx, forKey: "probEx")
        UserDefaults.standard.set(GVar.probRep, forKey: "probRep")
        UserDefaults.standard.set(GVar.workoutDayRemaining, forKey: "workoutDayRemaining")
        UserDefaults.standard.set(GVar.todaysWorkout, forKey: "todaysWorkout")
        UserDefaults.standard.set(GVar.currDate, forKey: "currDate")
        UserDefaults.standard.set(GVar.allStats, forKey: "allStats")
        UserDefaults.standard.set(GVar.consecutiveWorkouts, forKey: "consecutiveWorkouts")
        UserDefaults.standard.set(GVar.workoutBegun, forKey: "workoutBegun")
        UserDefaults.standard.set(GVar.workoutComp, forKey: "workoutComp")
        UserDefaults.standard.set(GVar.exNumber, forKey: "exNumber")
        UserDefaults.standard.set(GVar.exProgress, forKey: "exProgress")
        UserDefaults.standard.set(GVar.passFailBoolArray, forKey: "passFailBoolArray")
        UserDefaults.standard.set(GVar.cyclesCompleted, forKey: "cyclesCompleted")
    }
    
    
    //Restore variables from user defaults
    func restoreVariablesFromUserDefaults(){
        GVar.currEx = (UserDefaults.standard.object(forKey: "currEx") as? [[String]])!
        GVar.currRep = (UserDefaults.standard.object(forKey: "currRep") as? [[Int]])!
        GVar.probEx = (UserDefaults.standard.object(forKey: "probEx") as? [[Double]])!
        GVar.probRep = (UserDefaults.standard.object(forKey: "probRep") as? [[Double]])!
        GVar.workoutDayRemaining = (UserDefaults.standard.object(forKey: "workoutDayRemaining") as? [Int])!
        GVar.todaysWorkout = (UserDefaults.standard.object(forKey: "todaysWorkout") as? Int)!
        GVar.currDate = (UserDefaults.standard.object(forKey: "currDate") as? Date)!
        GVar.allStats = (UserDefaults.standard.object(forKey: "allStats") as? [[Int]])!
        GVar.consecutiveWorkouts = (UserDefaults.standard.object(forKey: "consecutiveWorkouts") as? Int)!
        GVar.workoutBegun = (UserDefaults.standard.object(forKey: "workoutBegun") as? Bool)!
        GVar.workoutComp = (UserDefaults.standard.object(forKey: "workoutComp") as? Bool)!
        GVar.exNumber = (UserDefaults.standard.object(forKey: "exNumber") as? Int)!
        GVar.exProgress = (UserDefaults.standard.object(forKey: "exProgress") as? [Bool])!
        GVar.passFailBoolArray = (UserDefaults.standard.object(forKey: "passFailBoolArray") as? [Bool])!
        GVar.cyclesCompleted = (UserDefaults.standard.object(forKey: "cyclesCompleted") as? Int)!
        
    }
    
    //function changing the value of randomInt to a new random integer
    func randInt(max: Int){
        randomInt = Int(arc4random_uniform(UInt32(max)))
    }
    
    //returns a random double between 0 and 1
    func randDouble() -> Double{
        return drand48()
    }
    
    //Fills an array with probabilites corresponding to each exercise
    func fillProbEx(){
        for x in 0...2{
            for _ in 0...(GVar.totEx[x].count-1){
                GVar.probEx[x].append(0.2)
            }
        }
    }
    
    //creates a new set of workouts for the user
    func createWorkout(){
        for x in 0...2 {
            //clear current exercise
            if (GVar.currEx[x].count != 0) {
                GVar.currEx[x].removeAll()
            }
            //clear current reps
            if (GVar.currRep[x].count != 0){
                GVar.currRep[x].removeAll()
            }
        }
        
        for x in 0...2 {
            for y in 0...4{
                //first exercise is always the same: main exercise (bench press, deadlift, backsquat)
                if (y == 0){
                    GVar.currEx[x].append(GVar.totEx[x][0])
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
        randInt(max: GVar.totEx[index].count)
        //if the new workout plan doesnt already contain the random selected one and then passes the probability test function then it is addded to the current workout and a random rep range is generated with it
        if (GVar.currEx[index].contains(GVar.totEx[index][randomInt]) || !passesProbTest(ex: GVar.totEx[index][randomInt], index: index, exercise: randomInt) ){
            lookForNewExercise(index: index)
        } else {
            GVar.currEx[index].append(GVar.totEx[index][randomInt])
            addRep(index: index)
        }
    }
    
    //Probablity test generates a random double...
    //If the random double is less than the corressponding double stored in the proability array then it passes the probTest
    func passesProbTest(ex: String, index: Int, exercise: Int) -> Bool {
        if(randDouble() < GVar.probEx[index][exercise]){
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
        if (randDouble() < GVar.probRep[index][randomIntRep]){
            GVar.currRep[index].append(GVar.totRep[index][randomIntRep])
        } else {
            addRep(index: index)
        }
    }
    
    //function that orders the array holding the current workout so that exercises are done/displayed in an order that follows exerise rule of ordering exercises from largest muscle group to smallest
    //Sorted with bubblesort
    func orderWorkout(){
        for x in 0...2{
            for _ in 0...GVar.currEx[x].count {
                for value in 1...GVar.currEx[x].count - 1 {
                    if (findIndex(of: GVar.currEx[x][value - 1], arr: GVar.totEx[x]) > findIndex(of: GVar.currEx[x][value], arr: GVar.totEx[x])) {
                        let largerValue = GVar.currEx[x][value-1]
                        GVar.currEx[x][value-1] = GVar.currEx[x][value]
                        GVar.currEx[x][value] = largerValue
                    }
                }
            }
        }
    }
    
    //function used to find if the randomly selected workout has already been selected
    func findIndex(of: String, arr: [String]) -> Int {
        for x in 0...arr.count {
            if (arr[x] == of){
                return x
            }
        }
        return -1
    }
    
    func setCurrDate(){
        if (GVar.currDate == nil){
            GVar.currDate = Date()
        }
    }
}
