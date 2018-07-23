//
//  AppDelegate.swift
//  Hummingbird
//
//  Created by Adam on 4/9/18.
//  Copyright © 2018 Adam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		StateManager.shared().sync()
		
		return true
	}
}

