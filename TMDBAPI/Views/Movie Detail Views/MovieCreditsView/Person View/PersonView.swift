//
//  CreditView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 30/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import Kingfisher
import KingfisherSwiftUI

// MARK: - PersonView
struct PersonView: View {
    
    // MARK: Properties
    @EnvironmentObject var fetcher: Fetcher
    @State private var person = Person.placeholder
    @State private var creditImage = UIImage()
    @State private var isPersonDetailsLoaded = false
    @State private var creditBiography = ""
    @State private var isPersonBiographyShoudExpanded = false
    @State private var homepageUrl = ""
    @State private var isHomepagePresented = false
    @State private var isIMDBPresented = false
    @State private var imdbpageUrl = ""
    
    
    let credit: Credit
    
    // MARK: Main View
    @ViewBuilder
    var body: some View {
    
        GeometryReader { g in
            ScrollView(.vertical, showsIndicators: true){
                
                VStack(spacing: 5) {
                    
                    self.personImageView
                    
                    self.personIdentificationView
                    
                    Divider()
                  
                    VStack(alignment: .leading, spacing: 8) {
                        Text("BIOGRAPHY").bold()
                        self.personBiographyView
                            .sheet(isPresented: self.$isPersonBiographyShoudExpanded) {
                               // PersonBiographyModalView(name: self.credit.creditName, biography: self.creditBiography)
                                ContentModalView(title: self.credit.creditName,
                                                 content: self.creditBiography,
                                                 isContentViewPresented: self.$isPersonBiographyShoudExpanded)
                        }
                    }
                    
                    Divider()
                    
                  //  if !self.fetcher.personMovies.0.isEmpty || !self.fetcher.personMovies.1.isEmpty {
                        FilmographyView(credit: self.credit, proxy: g)
                            .environmentObject(self.fetcher)
                        
                   // }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .opacity(self.isPersonDetailsLoaded ? 1 : 0)
        .onAppear {
            self.fetchCreditImage()
            
        }
        .onReceive(self.fetcher.$person) { (person) in
            if person.name == self.credit.creditName {
                self.person = person
                self.isPersonDetailsLoaded.toggle()
                debugPrint("person id: \(person.id)")
            }
        }
        .navigationBarTitle(self.credit.creditName)
        .sheet(isPresented: self.$isIMDBPresented) {
            SafariController(url: self.imdbpageUrl)
        }
    }
}

// MARK: - Views
fileprivate extension PersonView {
    
    // MARK: Person Image
    @ViewBuilder
    var personImageView: some View {
        if self.creditImage != UIImage() {
            Image(uiImage: self.creditImage)
                .resizable()
                .frame(width: (UIScreen.main.bounds.width / 3).rounded(),
                       height: ((UIScreen.main.bounds.width / 3) * 1.5).rounded())
                .scaledToFit()
                .cornerRadius(10)
        }
    }
    
    // MARK: Person Identification: Name, Birthday & Place of birthday
    @ViewBuilder
    var personIdentificationView: some View {
        
        VStack(spacing: 5) {
            
            // NAME
            Text(verbatim: "\(self.person.name.localizedUppercase)")
                .font(.system(size: 22, weight: .bold, design: .rounded))
          
            // Birthday, Place of birth, Death day
            Group {
                if !self.person.birthday.isNilAndEmpty {
                    Text("Born: \(self.person.birthday!)")
                }
                if !self.person.placeOfBirth.isNilAndEmpty {
                    Text("in \(self.person.placeOfBirth!)")
                }
                if !self.person.deathday.isNilAndEmpty {
                    Text("Decided on: \(self.person.deathday!)")
                }
            }
            .font(.system(size: 16, weight: .regular, design: .default))
            .multilineTextAlignment(.center)
            
            // Department
            if !self.person.knownForDepartment.isNilAndEmpty {
                Text(verbatim: "Department: \(self.person.knownForDepartment!)")
                    .font(.system(size: 16, weight: .semibold, design: .default))
            }
            
            // Home page
            if !self.person.homepage.isNilAndEmpty {
                personHomepageView
                    .sheet(isPresented: self.$isHomepagePresented) { SafariController(url: self.homepageUrl) }
            }
        }
        .padding(5)
        .layoutPriority(1)
        
    }
    
    // MARK: Person Biography
    @ViewBuilder
    var personBiographyView: some View {
        if !self.person.biography.isNilAndEmpty {
            VStack {
                Text(verbatim: "\(self.person.biography!)")
                    .font(.system(size: 16))
                
                if self.person.biography!.length > Int((UIScreen.height / 3)) {
                    biographyMoreButton
                }
 
                Spacer()
            }
            .frame(maxHeight: UIScreen.height / 3)
       
        } else  {
            imdbView
        }
    }
    
    // MARK: Person Home page
    var personHomepageView: some View {
        Button(action: {
            self.homepageUrl = self.person.homepage!
            self.isHomepagePresented.toggle()
            
        }) {
            Text("\(self.person.homepage!)")
                .font(.system(size: 16))
                .foregroundColor(Color(.systemBlue))
                .underline(true, color: Color(.systemBlue))
        }
    }
    
    // MARK: Person IMDB
    @ViewBuilder
    var imdbView: some View {
        if !self.person.imdbId.isNilAndEmpty {
            HStack(alignment: .firstTextBaseline, spacing: 1) {
                Text("No description provided. See more in ")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    self.imdbpageUrl = "https://www.imdb.com/name/\(self.person.imdbId!)"
                    self.isIMDBPresented.toggle()
                }) {
                    Text("IMDB")
                        .font(.system(size: 16))
                        .foregroundColor(Color(.systemBlue))
                        .underline()
                }
            }
        } else {
            Text("No description provided for \(self.credit.creditName).")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: Person Biography More Button
    @ViewBuilder
    var biographyMoreButton: some View {
        
        HStack {
            Spacer()
            Button(action: {
                self.creditBiography = self.person.biography!
                self.isPersonBiographyShoudExpanded = true
            }) {
                Text("More")
                    .font(.system(size: 16))
            }
        }
        
    }
    
    
    // MARK: Person Modal View
    struct PersonBiographyModalView: View {
        
        @Environment(\.presentationMode) var presentationMode
        
        let name: String
        let biography: String
        
        var body: some View {
            NavigationView {
                ScrollView(.vertical, showsIndicators: true) {
                        Text("\(self.biography)")
                            .font(.system(size: 16)).padding()
                }
                .frame(maxHeight: .infinity)
                .navigationBarTitle(Text("\(self.name) biography"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: { Text("Done") } ))
            }
        }
    }
}

// MARK: - Helpers
fileprivate extension PersonView {
 
    func fetchCreditImage() {
        if let imagePath = self.credit.creditProfilePath {
            ImageCache.default.retrieveImage(forKey: imagePath) { (res) in
                do {
                    let resultCache = try res.get()
                    if let img = resultCache.image {
                        self.creditImage = img
                    }
                } catch {
                    debugPrint("Credit image error : \(error.localizedDescription)")
                }
            }
        }
    }
}
