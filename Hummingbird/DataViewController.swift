//
//  PageViewController.swift
//  Hummingbird
//
//  Created by Adam on 4/9/18.
//  Copyright © 2018 Adam. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, SceneDelegate
{
	var dataViewModel : PageViewModel!
	
	var viewsConfigured : Bool = false
	
	init(withDataViewModel dataViewModel : PageViewModel) {
		self.dataViewModel = dataViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if !viewsConfigured {
			self.dataViewModel.scene.configureView(self.view)
			self.dataViewModel.scene.delegate = self
			self.dataViewModel.passage.configureView(self.view)
			viewsConfigured = true
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if StateManager.shared().autoplayEnabled() {
			(self.dataViewModel.passage as! PagePassage).startSpeaking()
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.dataViewModel.scene.sceneWillDisappear()
		(self.dataViewModel.passage as! PagePassage).stopSpeaking()
	}
	
	func onHomePressed() {
		NotificationCenter.default.post(name: .toHome, object: nil)
	}

}

