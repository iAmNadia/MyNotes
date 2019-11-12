
import UIKit
import CocoaLumberjack
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var container: NSPersistentContainer!
    
    func createContainer(completion: @escaping (NSPersistentContainer) -> ()) {
        let container = NSPersistentContainer(name: "Notes")
        container.loadPersistentStores(completionHandler: {_, error in
            guard error == nil else {fatalError("Failed to load store")}
            DispatchQueue.main.async {
                completion(container)
            }
        })
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupLogger()
        createContainer {container in
            self.container = container
            if let tbc = self.window?.rootViewController as? UITabBarController,
                            let nc = tbc.selectedViewController as? UINavigationController,
                            let vc = nc.topViewController as? NotesViewController {
                            print("vc exists")
                            vc.context = container.viewContext
                            vc.backgroundContext = container.newBackgroundContext()
                            vc.loadNotes()
                        } else {
                            print("Set fields FAILED!")
                        }
                    }
                    DDLogInfo("exec application()")
//            if let tc = self.window?.rootViewController as? UITabBarController {
//                if let nc = tc.viewControllers?[0] as? UINavigationController {
//                    if let nlv = nc.topViewController as? NotesViewController {
//                        print("init context")
//                        nlv.backgroundContext = container.newBackgroundContext()
//                    }
//                }
//            }
//        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called i	ackground, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // FileNotebook.shared.saveToFile()
    }
}
extension AppDelegate {
    
    fileprivate func setupLogger() {
        DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    
}
