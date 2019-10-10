//
//  String+Extensions.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 30/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI

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

}

func detectData(in str: String) -> NSAttributedString {
    
    let attributesString = NSMutableAttributedString(string: str)
    
    let types: NSTextCheckingResult.CheckingType = [.date, .link]
    
    let dataDetector = try? NSDataDetector(types: types.rawValue)
    
    
    /*dataDetector?.enumerated().forEach({ (offset, result) in
        if result.resultType.contains(.link) {
            debugPrint(offset, result, result.range)
            attributesString.addAttributes([NSAttributedString.Key.backgroundColor : UIColor.red], range: result.range)
        }
    })*/
    
   // var attributesString = NSMutableAttributedString()
    
    dataDetector?.enumerateMatches(in: str, options: [], range: NSRange(location: 0, length: str.utf16.count), using: { (match, flags, _) in
        
        guard let unwrappedMatch = match else { return }
        
        let matchString = (str as NSString).substring(with: unwrappedMatch.range)
     //   let _attributesString = NSMutableAttributedString(attributedString: .init(string: matchString))
        
        
        switch unwrappedMatch.resultType {
        case .link:
            
            attributesString.addAttribute(NSAttributedString.Key.link, value: matchString, range: unwrappedMatch.range)
            
        default:
            break
        }
    })
   // debugPrint(attributesString)
    return attributesString
}
