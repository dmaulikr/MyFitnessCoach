//
//  AppDelegate.swift
//  MyFitnessCoach
//
//  Created by Andrew Meng on 2017-03-25.
//  Copyright © 2017 Andrew Meng. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow.init(frame : UIScreen.main.bounds)
        
        window!.backgroundColor = UIColor.white
        
        let searchNav = UINavigationController()
        let searchVC = HomeVC()
        searchNav.viewControllers = [searchVC]
        searchNav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "searchTabIcon"), tag: 1)
        
        let homeNav = UINavigationController()
        let homeVC = HomeVC()
        homeNav.viewControllers = [homeVC]
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeTabIcon"), tag: 1)
        
        let routinesNav = UINavigationController()
        let routinesVC = RoutinesVC()
        routinesNav.viewControllers = [routinesVC]
        routinesNav.tabBarItem = UITabBarItem(title: "Exercises", image: UIImage(named: "exercisesTabIcon"), tag: 1)
        
        let settingsNav = UINavigationController()
        let settingsVC = RoutineViewerVC()
        settingsNav.viewControllers = [settingsVC]
        settingsVC.routine = DMM.getRoutines()?[0]
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settingsTabIcon"), tag: 1)
        
        let tabs = UITabBarController()
        tabs.viewControllers = [searchNav, routinesNav, homeNav, settingsNav]
        UITabBar.appearance().barTintColor = UIColor(red: 78/255, green: 179/255, blue: 212/255, alpha: 1)
        UITabBar.appearance().tintColor = UIColor.white
        tabs.selectedViewController = homeNav
        
        self.window!.rootViewController = tabs
        self.window!.makeKeyAndVisible()
        
        return true
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
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIViewController {
    func tabPushViewController(VC: UIViewController, animated: Bool) {
        guard let tabController = self as? UITabBarController else { return }
        let currentIndex = tabController.selectedIndex
        
        (tabController.childViewControllers[currentIndex] as? UINavigationController)?.pushViewController(VC, animated: animated)
    }
}

