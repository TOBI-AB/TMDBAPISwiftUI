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

// MARK: - Movie Credits View
struct MovieCreditsView: View {
	
	@EnvironmentObject var fetcher: Fetcher
	@State private var credits = [Credit]()
		
	var body: some View {
		GeometryReader { g in
				ScrollView(.horizontal, showsIndicators: false) {
					HStack {
						ForEach(self.credits, id:\.creditIdentifier) { credit in
							MovieCreditRow(credit: credit, proxy: g).environmentObject(self.fetcher)
						}
					}
				}
				.onReceive(self.fetcher.$creditPickerSelection) { res in
					self.credits = (res == 0 ) ? self.fetcher.credits.0 : self.fetcher.credits.1
				}
		}
	}
}
//fileprivate
// MARK: - Movie Credit Row
extension MovieCreditsView {

    struct MovieCreditRow: View {
	
		@EnvironmentObject var fetcher: Fetcher
		@State private var selection: Int? = nil
		let credit: Credit
		let proxy: GeometryProxy
		
		init(credit: Credit, proxy: GeometryProxy) {
			self.credit = credit
			self.proxy = proxy
		
		}
				
		@ViewBuilder
		var bottomView: some View {
			if credit.creditProfilePath != nil {
				ZStack {
					KFImage(source: .network(ImageResource(downloadURL: TMDBAPI.getMoviePosterUrl(credit.creditProfilePath)!,cacheKey: credit.creditProfilePath)))
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
				
				VStack {
					
					Text(verbatim: self.credit.creditName)
						.bold()
                        .font(.system(size: 13))
						.lineLimit(1)
					
					if !self.credit.extraInfo.isEmpty {
						Text(verbatim: self.credit.extraInfo)
							.font(.system(size: 12))
							.lineLimit(2)
					}
				}
				.multilineTextAlignment(.center)
				.foregroundColor(credit.creditProfilePath != nil ? .white : .black)
			//	.padding(.horizontal, 5)
				.padding(5)
				
				NavigationLink(destination: PersonView(credit: self.credit).environmentObject(self.fetcher), tag: 0, selection: self.$selection) {
					EmptyView()
				}
			}
			.frame(width: proxy.frame(in: .global).size.width * 0.3, height: proxy.frame(in: .global).size.height)
			.cornerRadius(10)
			.onTapGesture {
                self.fetcher.personMovies.0.removeAll()
                self.fetcher.personMovies.1.removeAll()
                self.fetcher.fetchPersonDetails(self.credit)
                self.fetcher.fetchPersonMovies(self.credit)
				self.selection = 0
			}
		}
	}
}
