//
//  FilmographyView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 04/10/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import Kingfisher

struct PersonMoviesView: View {
    @EnvironmentObject private var fetcher: Fetcher
    
    var body: some View {
        Text("Person movie view")
    }
}

/*struct PersonMoviesView: View {
    
    @EnvironmentObject private var fetcher: Fetcher
    
    let credit: Credit
    let proxy: GeometryProxy
    
    @State private var personMovies = [Credit]()
    
    init(credit: Credit, proxy: GeometryProxy) {
        self.credit = credit
        self.proxy = proxy
    }
    
    var body: some View {
       
        VStack(alignment: .leading) {
            
            Text("FILMOGRAPHY").bold()
            
            PickerView(selection: self.$fetcher.personMoviesPickerSelection, data: ["As Cast", "As Crew"])
                .padding(.vertical, 2)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(personMovies, id: \.creditIdentifier) { credit in
                        FilmographyRowView(credit: credit)
                            .environmentObject(self.fetcher)
                            .frame(width: self.proxy.frame(in: .global).size.width * 0.3,
                                   height: self.proxy.frame(in: .global).size.height * 0.25)
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .onReceive(self.fetcher.$personMoviesPickerSelection) { (selection) in
            self.personMovies = (selection == 0) ? self.fetcher.personMovies.0 : self.fetcher.personMovies.1
        }
        .onReceive(self.fetcher.$personMovies) { personMovies in
            self.personMovies = (self.fetcher.personMoviesPickerSelection == 0) ? personMovies.0 : personMovies.1
        }
    }
}


struct FilmographyRowView: View {
    
    @EnvironmentObject private var fetcher: Fetcher
    @State private var selection: Int?
    
    let credit: Credit
    
    @ViewBuilder
    var body: some View {
        
          ZStack(alignment: .bottom) {
          /*  ZStack {
                KFImage(TMDBAPI.getMoviePosterUrl(credit.creditProfilePath))//, options: [.cacheOriginalImage])
                    .resizable()
                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .center, endPoint: .bottom)
            }*/
            
            VStack {
                Text("\(credit.extraInfo)")
                    .bold()
                    .font(.system(size: 13))
                    .lineLimit(1)
                Text("\(credit.creditName)")
                    .font(.system(size: 12))
                    .lineLimit(2)
            }
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding(5)
            
          /*  NavigationLink(destination: MovieDetailsView(movieId: self.credit.ID), tag: 0, selection: self.$selection) {
                EmptyView()
            }*/
            
        }
        .cornerRadius(10)
        .onTapGesture {
            // Clean Movie Details View
            self.fetcher.movieDetails = Movie.placeholder
            
            // Fire Navigation Link
            self.selection = 0
            
            debugPrint("ID ---------------->",self.credit)
        }
    }
}*/

