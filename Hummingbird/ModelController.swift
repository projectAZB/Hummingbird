//
//  ModelController.swift
//  Hummingbird
//
//  Created by Adam on 4/9/18.
//  Copyright © 2018 Adam. All rights reserved.
//

import UIKit

class ModelController : NSObject, UIPageViewControllerDataSource {

	var pageData: [PageViewModel]
	
	init(withPageViewModels pageViewModels : [PageViewModel])
	{
		self.pageData = pageViewModels
	}

	func viewControllerAtIndex(_ index: Int) -> DataViewController? {
		// Return the data view controller for the given index.
		if (self.pageData.count == 0) || (index >= self.pageData.count) {
		    return nil
		}

		let dataViewController = DataViewController.init(withDataViewModel: self.pageData[index])
		return dataViewController
	}

	func indexOfViewController(_ viewController: DataViewController) -> Int {
		return pageData.index(of: viewController.dataViewModel) ?? NSNotFound
	}

	// MARK: - Page View Controller Data Source

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
	    var index = self.indexOfViewController(viewController as! DataViewController)
	    if (index == 0) || (index == NSNotFound) {
	        return nil
	    }
	    
	    index -= 1
		StateManager.shared().setLastPage(index)
	    return self.viewControllerAtIndex(index)
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
	    var index = self.indexOfViewController(viewController as! DataViewController)
	    if index == NSNotFound {
	        return nil
	    }
	    
	    index += 1
	    if index == self.pageData.count {
	        return nil
	    }
		StateManager.shared().setLastPage(index)
	    return self.viewControllerAtIndex(index)
	}

}

