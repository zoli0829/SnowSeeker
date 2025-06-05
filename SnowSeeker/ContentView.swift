//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Zoltan Vegh on 02/06/2025.
//

import SwiftUI

struct ContentView: View {
    enum SortType: String, CaseIterable, Identifiable {
        case `default` = "Default"
        case alphabetical = "Alphabetical"
        case country = "Country"
        
        var id: String {self.rawValue}
    }
    
    @State private var sortType: SortType = .default
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var favorites = Favorites()
    @State private var searchText = ""
    
    var filteredResorts: [Resort] {
        let filtered: [Resort]
        
        if searchText.isEmpty {
            filtered = resorts
        } else {
            filtered = resorts.filter { $0.name.localizedStandardContains(searchText)}
        }
        
        switch sortType {
        case .default:
            return filtered
        case .alphabetical:
            return filtered.sorted { $0.name < $1.name }
        case .country:
            return filtered.sorted { $0.country < $1.country }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(filteredResorts) { resort in
                NavigationLink(resort.name) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(.rect(cornerRadius: 5))
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            }
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            
                            Text("\(resort.runs) runs")
                                .foregroundStyle(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundStyle(.red)
                                
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .navigationDestination(for: Resort.self) { resort in
                ResortView(resort: resort)
            }
            .searchable(text: $searchText, prompt: "Search for a resort")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Picker("Sort", selection: $sortType) {
                        ForEach(SortType.allCases) {sort in
                            Text(sort.rawValue)
                        }
                    }
                }
            }
            
            Text("Detail view")
        } detail: {
            WelcomeView()
        }
        .environment(favorites)
    }
}

#Preview {
    ContentView()
}
