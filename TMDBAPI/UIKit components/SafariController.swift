//
//  SafariController.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 02/10/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariController: UIViewControllerRepresentable {
	
	typealias UIViewControllerType = SFSafariViewController
	
	let url: String
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<SafariController>) -> SFSafariViewController {
		guard let url = URL(string: self.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
			fatalError("Invalid url: \(self.url)")
		}
		
		let controller = SFSafariViewController(url: url)
		return controller
	}
	
	func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariController>) {
		
	}
}
