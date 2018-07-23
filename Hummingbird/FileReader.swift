//
//  FileReader.swift
//  Hummingbird
//
//  Created by Adam on 4/16/18.
//  Copyright © 2018 Adam. All rights reserved.
//

import Foundation

class FileReader {
	
	static func stringContentsOfTxtFile(_ filename : String) -> String {
		if let fileUrl = Bundle.main.path(forResource: filename, ofType: Extensions.TXT) {
			do {
				let fileContents = try String.init(contentsOfFile: fileUrl)
				return fileContents
			}
			catch {
				print("Failed reading from URL: \(fileUrl), Error: " + error.localizedDescription)
			}
		}
		return ""
	}
}
