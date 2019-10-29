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
        setViewController(viewController: new, title: "最新", image: "new_normal", selectedImage: "new_selected")
        let category = CategoryViewController()
        setViewController(viewController: category, title: "分类", image: "category_normal", selectedImage: "category_selected")
        let free = FreeViewController()
        setViewController(viewController: free, title: "闲读", image: "free_normal", selectedImage: "free_selected")
        let mine = MineViewController()
        setViewController(viewController: mine, title: "我的", image: "mine_normal", selectedImage: "mine_selected")

        tab.viewControllers = [new, category, free, mine];
        let nav = UINavigationController(rootViewController: tab)
        self.window?.rootViewController = nav

        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().isTranslucent = false
        return true
    }
    
    func setViewController(viewController: UIViewController, title: String, image: String, selectedImage:String) {
        let bar = viewController.tabBarItem
        bar?.title = title
        let attr:Dictionary = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.black]
        bar?.setTitleTextAttributes(attr, for: UIControl.State.selected)
        
        let normal = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        let selected = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
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

