//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Zoltan Vegh on 03/06/2025.
//

import SwiftUI

struct ResortView: View {
    let resort: Resort
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(Favorites.self) var favorites
    
    @State private var selectedFacility: Facility?
    @State private var showingFacility = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    Image(decorative: resort.id)
                        .resizable()
                        .scaledToFit()
                    
                    Text("Photo: \(resort.imageCredit)")
                        .font(.caption)
                        .padding(6)
                        .background(.black.opacity(0.6))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    padding([.bottom, .trailing])
                    
                }
                
                HStack {
                    if horizontalSizeClass == .compact && dynamicTypeSize > .large {
                        VStack(spacing: 10) { ResortDetailsView(resort: resort) }
                        VStack(spacing: 10) { SkiDetailsView(resort: resort) }
                    } else {
                        ResortDetailsView(resort: resort)
                        SkiDetailsView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(.primary.opacity(0.1))
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            Button {
                                selectedFacility = facility
                                showingFacility = true
                            } label: {
                                facility.icon
                                    .font(.title)
                            }
                        }
                    }
                        .padding(.vertical)
                    
                    Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                        if favorites.contains(resort) {
                            favorites.remove(resort)
                        } else {
                            favorites.add(resort)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        .alert(selectedFacility?.name ?? "More Information", isPresented: $showingFacility) { _ in
        } message: { facility in
            Text(facility.description)
        }
    }
}

#Preview {
    ResortView(resort:.example)
        .environment(Favorites())
}
