//
//  String+Extensions.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 30/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

extension String {
    
    var length: Int {
        NSRange(location: 0, length: self.utf16.count).length
    }
    
    var linesNumber: Int {
        self.split(separator: ",").count
    }
    
    var toCountryName: String {
        let countryName = NSLocale.current.localizedString(forRegionCode: self) ?? ""
        
        return countryName
    }
	
	var sentences: [String] {
        stringArrayWithUnit(.sentence)
		
	}
	
	var paragraphs: [String] {
        stringArrayWithUnit(.paragraph)
	}
    
    var words: [String] {
        stringArrayWithUnit(.word)
    }

    
    fileprivate func stringArrayWithUnit(_ unit: NSLinguisticTaggerUnit) -> [String] {
        var strArray = [String]()
        let tagger = NSLinguisticTagger(tagSchemes: [.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
        
        tagger.string = self
        let range = NSRange(location: 0, length: self.utf16.count)
        
        tagger.enumerateTags(in: range, unit: unit, scheme: .tokenType, options: []) { (tag, tokenRange, stop) in
            let str = (self as NSString).substring(with: tokenRange)
            strArray.append(str)
        }
        
        return strArray
    }
}

