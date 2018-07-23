//
//  PageViewModel.swift
//  Hummingbird
//
//  Created by Adam on 4/10/18.
//  Copyright © 2018 Adam. All rights reserved.
//

import Foundation

struct PageViewModel : Equatable
{
	static var count : Int = 0
	
	let passage : Passage
	let scene : Scene
	
	init(withPassage passage : Passage, scene : Scene) {
		//PageViewModel.count += 1
		self.passage = passage
		self.scene = scene
	}
}
