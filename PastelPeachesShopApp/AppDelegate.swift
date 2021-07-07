//
//  AppDelegate.swift
//  5IOSMD_AssignmentPart2
//
//  Created by Kizzie Mae MARTINEZ (001105383) on 5/3/21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var ItemArray = [Item]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        copyDatabase()        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    // MARK: - Database
    func getDBPath()->String{
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)
        let documentsDir = paths[0]
        let databasePath = (documentsDir as NSString).appendingPathComponent("ShopDB.db")
        return databasePath;
    }
    //Copy the database to the device from the project folder
    func copyDatabase(){
        let fileManager = FileManager.default
        let dbPath = getDBPath()
        var success = fileManager.fileExists(atPath: dbPath)
        if(!success){
            if let defaultDBPath = Bundle.main.path(forResource: "ShopDB", ofType: "db"){
                var error:NSError?
                do{
                    try fileManager.copyItem(atPath: defaultDBPath, toPath: dbPath)
                    success = true
                } catch let error1 as NSError {
                    error = error1
                    success = false
                }
                print(defaultDBPath)
                if(!success){
                    print("Failed to create writable database file with message\(error!.localizedDescription))")
                }
            } else{
                print("Cannot Find File In NSBundle")
            }
        }else{
            print("File Already Exist At:\(dbPath)")
        }
    }
    

}

