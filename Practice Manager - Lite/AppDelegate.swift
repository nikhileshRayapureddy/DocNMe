//
//  AppDelegate.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 31/07/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import CoreData
import SideMenuController
import IQKeyboardManagerSwift
import RealmSwift
let ScreenWidth =  UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let app_delegate =  UIApplication.shared.delegate as! AppDelegate
var loggedInDoctor = DoctorModel()
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OnSynchronizerStateChanged {

    var window: UIWindow?
    var timerSynch: Timer?;
    var isServerReachable : Bool = false
    var reachability: Reachability?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent;
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 300
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay

        startMigrationRealm();

        IQKeyboardManager.sharedManager().enable = true;
        startParsingFilesAllergies();
        startTimer();
        self.setupReachability(hostName: "", useClosures: true)
        self.startNotifier()
        print("reachable = ",isServerReachable)
        isServerReachable = (reachability?.isReachable)!
        print("reachable after= ",isServerReachable)

        return true;
    }

    private func startMigrationRealm() {
//        let config = Realm.Configuration(
//                // Set the new schema version. This must be greater than the previously used
//                // version (if you've never set a schema version before, the version is 0).
//                schemaVersion: 2,
//
//                // Set the block which will be called automatically when opening a Realm with
//                // a schema version lower than the one set above
//                migrationBlock: { migration, oldSchemaVersion in
//                    // We haven’t migrated anything yet, so oldSchemaVersion == 0
//                    if (oldSchemaVersion < 2) {
//                        // Nothing to do!
//                        // Realm will automatically detect new properties and removed properties
//                        // And will update the schema on disk automatically
//
//                    }
//                })
//
//// Tell Realm to use this new configuration object for the default Realm
//        Realm.Configuration.defaultConfiguration = config
//
//// Now that we've told Realm how to handle the schema change, opening the file
//// will automatically perform the migration
//        let realm = try! Realm()

    }

    func startParsingFilesMedicin() {

        if let url = Bundle.main.url(forResource: "medicines1", withExtension: "txt") {
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: url)
                    let attibutedString = try NSAttributedString(data: data, documentAttributes: nil)
                    let fullText = attibutedString.string
                    let readings = fullText.components(separatedBy: CharacterSet.newlines)
                    let realm = try? Realm();
                    for line in readings { // do not use ugly C-style loops in Swift
//                        let clientData = line.components(separatedBy: "\t")
                        let medicine = MedicineModel();
                        try? realm?.write({
                            medicine.name = line;
                            realm?.add(medicine);
                        })
                    }
                } catch {
                    print(error)
                }
            }
        }

        if let url = Bundle.main.url(forResource: "medicines2", withExtension: "txt") {
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: url)
                    let attibutedString = try NSAttributedString(data: data, documentAttributes: nil)
                    let fullText = attibutedString.string
                    let readings = fullText.components(separatedBy: CharacterSet.newlines)
                    let realm = try? Realm();
                    for line in readings { // do not use ugly C-style loops in Swift
//                        let clientData = line.components(separatedBy: "\t")
                        let medicine = MedicineModel();
                        try? realm?.write({
                            medicine.name = line;
                            realm?.add(medicine);
                        })
                    }
                } catch {
                    print(error)
                }
            }

        }

        if let url = Bundle.main.url(forResource: "medicines3", withExtension: "txt") {
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: url)
                    let attibutedString = try NSAttributedString(data: data, documentAttributes: nil)
                    let fullText = attibutedString.string
                    let readings = fullText.components(separatedBy: CharacterSet.newlines)
                    let realm = try? Realm();
                    for line in readings { // do not use ugly C-style loops in Swift
                        //                        let clientData = line.components(separatedBy: "\t")
                        let medicine = MedicineModel();
                        try? realm?.write({
                            medicine.name = line;
                            realm?.add(medicine);
                        })
                    }
                } catch {
                    print(error)
                }
            }

        }

        if let url = Bundle.main.url(forResource: "medicines4", withExtension: "txt") {
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: url)
                    let attibutedString = try NSAttributedString(data: data, documentAttributes: nil)
                    let fullText = attibutedString.string
                    let readings = fullText.components(separatedBy: CharacterSet.newlines)
                    let realm = try? Realm();
                    for line in readings { // do not use ugly C-style loops in Swift
                        //                        let clientData = line.components(separatedBy: "\t")
                        let medicine = MedicineModel();
                        try? realm?.write({
                            medicine.name = line;
                            realm?.add(medicine);
                        })
                    }
                } catch {
                    print(error)
                }
            }

        }


    }

    func startParsingFilesAllergies() {
        let realm = try? Realm();
        let results = realm?.objects(AllergiesModel.self);
        if (results != nil && (results!.count) > 0) {
            return;
        }

        startParsingFilesMedicin();


        if let url = Bundle.main.url(forResource: "allergies", withExtension: "txt") {
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: url)
                    let attibutedString = try NSAttributedString(data: data, documentAttributes: nil)
                    let fullText = attibutedString.string
                    let readings = fullText.components(separatedBy: CharacterSet.newlines)
                    let realm = try? Realm();
                    for line in readings { // do not use ugly C-style loops in Swift
//                        let clientData = line.components(separatedBy: "\t")
                        try? realm?.write({
                            let allergy = AllergiesModel();
                            allergy.name = line;
                            realm?.add(allergy);
                        })
                    }
                } catch {
                    print(error)
                }
            }

        }


    }

    func startTimer() {
        var time = UserPrefUtil.getScheduledTimeInSeconds();
        if time == nil {
            time = 30;
        }
        do {
            if self.timerSynch == nil {
                self.timerSynch = Timer.scheduledTimer(
                        timeInterval: TimeInterval(time!),
                        target: self,
                        selector: #selector(syncNow(_:)),
                        userInfo: nil,
                        repeats: true)
            }
        }
    }


    @objc func syncNow(_: Any?) {
//        let realm = try? Realm();
        Synchronizer.syncData(self);
    }

    func stopTimerTest() {
        if self.timerSynch != nil {
            self.timerSynch?.invalidate()
            self.timerSynch = nil
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Practice_Manager___Lite")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    @available(iOS 10.0, *)
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    //MARK:- Reachability

    func setupReachability(hostName: String?, useClosures: Bool) {
        
        let reachabil = hostName == "" ? Reachability() : Reachability(hostname: hostName!)
        reachability = reachabil
        if useClosures {
            reachability?.whenReachable = { reachability in
                DispatchQueue.main.async {
                    self.isServerReachable = true
                }
            }
            reachability?.whenUnreachable = { reachability in
                DispatchQueue.main.async {
                    self.isServerReachable = false
                }
            }
            print("reachable setup = ",isServerReachable)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        }
    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
    }
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            isServerReachable = true
        } else {
            isServerReachable = false
        }
    }
    
    deinit {
        stopNotifier()
    }

    //MARK:- Loader  methods
    func showLoader(message:String)
    {
        
        DispatchQueue.main.async {
            let vwBgg = self.window!.viewWithTag(123453)
            if vwBgg == nil
            {
                let vwBg = UIView( frame:self.window!.frame)
                vwBg.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                vwBg.tag = 123453
                self.window!.addSubview(vwBg)
                
                //                let imgVw = UIImageView (frame: vwBg.frame)
                //                imgVw.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                //                vwBg.addSubview(imgVw)
                
                let height = vwBg.frame.size.height/2.0
                
                let lblText = UILabel(frame:CGRect(x: 0, y: height-60, width: vwBg.frame.size.width, height: 30))
                lblText.font = UIFont(name: "OpenSans", size: 17)
                lblText.tag = 2324
                if message == ""
                {
                    lblText.text =  "Loading ..."
                }
                else
                {
                    lblText.text = message
                }
                lblText.textAlignment = NSTextAlignment.center
                lblText.backgroundColor = UIColor.clear
                lblText.textColor =   UIColor.white// Color_AppGreen
                // lblText.textColor = Color_NavBarTint
                vwBg.addSubview(lblText)
                
                
                
                let indicator = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
                indicator.center = vwBg.center
                vwBg.addSubview(indicator)
                indicator.startAnimating()
                indicator.tag = 2325
                vwBg.addSubview(indicator)
                indicator.bringSubview(toFront: vwBg)
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
            }
        }
    }
    func reloadLoader()
    {
        DispatchQueue.main.async {
            
            if let vwBgg = self.window!.viewWithTag(123453)
            {
                vwBgg.frame = self.window!.frame
                if let indicator = vwBgg.viewWithTag(2325)
                {
                    indicator.center = vwBgg.center
                }
                if let lblText = vwBgg.viewWithTag(2324)
                {
                    let height = vwBgg.frame.size.height/2.0
                    lblText.frame = CGRect(x: 0, y: height-60, width: vwBgg.frame.size.width, height: 30)
                }
                
            }
        }
    }
    func removeloder()
    {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            let vwBg = self.window!.viewWithTag(123453)
            if vwBg != nil
            {
                vwBg!.removeFromSuperview()
            }
        }
    }

}

