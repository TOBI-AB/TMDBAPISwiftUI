//
//  MovieCreditsView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 27/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import Combine
import KingfisherSwiftUI
import Kingfisher

// MARK: - Movie Cast View
struct MovieCastView: View {
	
	@EnvironmentObject var fetcher: Fetcher
	@State private var credits = [Credit]()
	
	let movie: Movie
	
	var body: some View {
		GeometryReader { g in
				ScrollView(.horizontal, showsIndicators: false) {
					HStack {
						ForEach(self.credits, id:\.ID) { credit in
							MovieCastRow(credit: credit, proxy: g)
						}
					}
				}
				.onReceive(self.fetcher.$creditPickerSelection) { res in
					self.credits = (res == 0 ) ? self.fetcher.credits.0 : self.fetcher.credits.1
				}
		}
	}
}

// MARK: - Movie Cast Row
extension MovieCastView {
	fileprivate	struct MovieCastRow: View {
		let credit: Credit
		let proxy: GeometryProxy
		
		@ViewBuilder
		var bottomView: some View {
				if credit.creditProfilePath != nil {
					ZStack {
						KFImage(source: .network(ImageResource(downloadURL: TMDBAPI.getMoviePosterUrl(credit.creditProfilePath!)!,cacheKey: credit.creditProfilePath)))
							.resizable()
						LinearGradient(gradient: Gradient(colors: [.clear, .black]),
									   startPoint: .center,
									   endPoint: .bottom)
					}
					
				} else {
					ZStack {
						Rectangle()
							.fill(Color(.white))
						Image(systemName: "person.fill")
							.foregroundColor(Color(.systemGray).opacity(0.5))
							
					}
					.overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color(.systemGray).opacity(0.5),
																			 lineWidth: 1,
																			 antialiased: true))
			}
		}
		
		var body: some View {
			
			ZStack(alignment: .bottom) {
				
				bottomView
		
				VStack(alignment: .center) {
				
					Text(verbatim: self.credit.creditName)
						.font(.system(size: 13)).bold()
						.lineLimit(1)
				
					if !self.credit.extraInfo.isEmpty {
						Text(verbatim: self.credit.extraInfo)
							.font(.system(size: 12))
							.lineLimit(2)
					}
				}
				.multilineTextAlignment(.center)
				.foregroundColor(credit.creditProfilePath != nil ? .white : .black)
				.padding(.horizontal, 5)
				.padding(.bottom, 5)
			}
			.frame(width: proxy.frame(in: .global).size.width * 0.3, height: proxy.frame(in: .global).size.height)
			.cornerRadius(10)
			.onTapGesture {
				//debugPrint(self.credit.extraInfo, self.credit.type)
				
			}
		}
	}
}
