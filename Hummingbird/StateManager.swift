//
//  StateManager.swift
//  Hummingbird
//
//  Created by Adam on 4/15/18.
//  Copyright © 2018 Adam. All rights reserved.
//

import Foundation

@objc class StateManager : NSObject {
	
	private var autoplay : Bool = false
	private var lastPage : Int = 0 {
		didSet {
			if lastPage == 5 {
				lastPage = 0
			}
		}
	}
	
	private static var sharedStateManager : StateManager = {
		let stateManager = StateManager()
		return stateManager
	}()
	
	private override init() {
		
	}
	
	class func shared() -> StateManager {
		return self.sharedStateManager
	}
	
	func autoplayEnabled() -> Bool {
		return self.autoplay
	}
	
	func putAutoplayOn() {
		UserDefaults.standard.set(true, forKey: Keys.Autoplay)
		self.autoplay = true
	}
	
	func turnAutoplayOff() {
		UserDefaults.standard.set(false, forKey: Keys.Autoplay)
		self.autoplay = false
	}
	
	func setLastPage(_ index : Int) {
		UserDefaults.standard.set(index, forKey: Keys.PageIndex)
		self.lastPage = index
	}
	
	func getLastPage() -> Int {
		return self.lastPage
	}
	
	func sync() {
		self.autoplay = UserDefaults.standard.bool(forKey: Keys.Autoplay) //returns false if no key
		self.lastPage = UserDefaults.standard.integer(forKey: Keys.PageIndex) //returns 0 if no key
	}
}
