//
//  String+Extensions.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 30/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI

extension String {
    
    var toDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        
        return formatter.date(from: self) ?? Date()
    }
    
    var length: Int {
        NSRange(location: 0, length: self.utf16.count).length
    }
    
    var linesNumber: Int {
        self.split(separator: ",").count
    }
    
    // MARK: Get the country name from string
    var toCountryName: String {
        let countryName = NSLocale.current.localizedString(forRegionCode: self) ?? ""
        
        return countryName
    }
    
	// MARK: Get the sentences count
	var sentences: [String] {
        stringArrayWithUnit(.sentence)
		
	}
    
	// MARK: Get the paragraphs count
	var paragraphs: [String] {
        stringArrayWithUnit(.paragraph)
	}
    
    // MARK: Get the words count
    var words: [String] {
        stringArrayWithUnit(.word)
    }

    
    // MARK: Split string according to linguistic tagger
    fileprivate func stringArrayWithUnit(_ unit: NSLinguisticTaggerUnit) -> [String] {
        var strArray = [String]()
        let tagger = NSLinguisticTagger(tagSchemes: [.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
       // let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
        
        tagger.string = self
        let range = NSRange(location: 0, length: self.utf16.count)
        
        tagger.enumerateTags(in: range, unit: unit, scheme: .tokenType, options: options) { (tag, tokenRange, stop) in
            let str = (self as NSString).substring(with: tokenRange)
            strArray.append(str)
        }
        
        return strArray
    }
    
    
    // MARK: Get attributes for the given string
    func attributes() -> NSAttributedString {
      
        let attributesString = NSMutableAttributedString(string: self)
        let types: NSTextCheckingResult.CheckingType = [.date, .link]
        
        guard let dataDetector = try? NSDataDetector(types: types.rawValue) else { return attributesString }
        
        dataDetector.enumerateMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count), using: { (match, flags, _) in
            
            guard let unwrappedMatch = match else { return }
            
            let matchString = (self as NSString).substring(with: unwrappedMatch.range)
            
            switch unwrappedMatch.resultType {
            case .link:
                attributesString.addAttribute(NSAttributedString.Key.link, value: matchString, range: unwrappedMatch.range)
            default:
                break
            }
        })
        return attributesString
    }
}
