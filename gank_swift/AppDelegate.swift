//
//  AppDelegate.swift
//  gank_swift
//
//  Created by keith on 2019/2/21.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        let tab = UITabBarController()
        
        let new = NewViewController()
        new.tabBarItem.title = "最新"
        new.tabBarItem.image = UIImage(named: "new_normal")
        new.tabBarItem.selectedImage = UIImage(named: "new_selected")

        let category = CategoryViewController()
        category.tabBarItem.title = "分类"
        category.tabBarItem.image = UIImage(named: "category_normal")
        category.tabBarItem.selectedImage = UIImage(named: "category_selected")

        let mine = MIneViewController()
        mine.tabBarItem.title = "分类"
        mine.tabBarItem.image = UIImage(named: "mine_normal")
        mine.tabBarItem.selectedImage = UIImage(named: "mine_selected")

        tab.viewControllers = [new,category,mine];
        let nav = UINavigationController(rootViewController: tab)
        self.window?.rootViewController = nav

        return true
    }
    
    func setViewController(viewController: UIViewController, title: String, image: String, selectedImage:String) {
        let bar = viewController.tabBarItem
        bar?.title = title
        
        let normal = UIImage(named: image)
        let selected = UIImage(named: selectedImage)
        bar?.image = normal
        bar?.selectedImage = selected
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


}

