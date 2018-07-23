//
//  HomeViewController.swift
//  Hummingbird
//
//  Created by Adam on 4/13/18.
//  Copyright © 2018 Adam. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController : UIViewController, MenuPassageDelegate
{
	var viewsConfigured : Bool = false
	
	lazy var dataViewModel : PageViewModel = {
		return PageViewModel.init(withPassage: MenuPassage.init(withFilename: nil), scene: Day.init())
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		StateManager.shared().sync()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if (!viewsConfigured) {
			self.dataViewModel.scene.configureView(self.view)
			self.dataViewModel.passage.configureView(self.view)
			(self.dataViewModel.passage as! MenuPassage).delegate = self as MenuPassageDelegate
			viewsConfigured = true
		}
	}
	
	func onAboutPressed() {
		let aboutVC : AboutViewController = AboutViewController(nibName: "AboutViewController", bundle: nil)
		aboutVC.modalPresentationStyle = .fullScreen
		self.present(aboutVC, animated: true, completion: nil)
	}
	
	func onSettingsPressed() {
		let settingsVC : SettingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settings") as! SettingsViewController
		settingsVC.modalPresentationStyle = .fullScreen
		self.present(settingsVC, animated: true, completion: nil)
	}
	
	func onStartPressed() {
		let rootVC : RootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "root") as! RootViewController
		if StateManager.shared().getLastPage() == 0 { //start story from beginning
			if let nav = self.navigationController {
				nav.pushViewController(rootVC, animated: true)
			}
		}
		else {
			let alert = UIAlertController(title: "Would you like to continue where you left off or start over?", message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
				if let nav = self.navigationController {
					nav.pushViewController(rootVC, animated: true)
				}
			}))
			alert.addAction(UIAlertAction(title: "Start Over", style: .default, handler: { (action) in
				StateManager.shared().setLastPage(0)
				if let nav = self.navigationController {
					nav.pushViewController(rootVC, animated: true)
				}
			}))
			self.present(alert, animated: true, completion: nil)
		}
	}
}
