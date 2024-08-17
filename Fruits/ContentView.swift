//
//  ContentView.swift
//  Fruits
//
//  Created by ALI MOOSA on 17/08/2024.
//

import SwiftUI

struct ContentView: View {
    let images = [
        "https://picsum.photos/800/600?random=1",
        "https://picsum.photos/800/600?random=2",
        "https://picsum.photos/800/600?random=3",
        "https://picsum.photos/800/600?random=4",
        "https://picsum.photos/800/600?random=5",
    ]
    
    @State private var searchText = ""
    @State private var searchBarOffset: CGFloat = 0
    @State private var isSearchBarStuck = false
    @State private var initialSearchBarOffset: CGFloat? = nil
    
    let itemsWithImages = [
        ("Apple", "https://picsum.photos/100/100?random=6"),
        ("Banana", "https://picsum.photos/100/100?random=7"),
        ("Cherry", "https://picsum.photos/100/100?random=8"),
        ("Date", "https://picsum.photos/100/100?random=9"),
        ("Fig", "https://picsum.photos/100/100?random=10"),
        ("Grape", "https://picsum.photos/100/100?random=11"),
        ("Kiwi", "https://picsum.photos/100/100?random=12"),
        ("Lemon", "https://picsum.photos/100/100?random=13"),
        ("Mango", "https://picsum.photos/100/100?random=14"),
        ("Nectarine", "https://picsum.photos/100/100?random=15"),
        ("Orange", "https://picsum.photos/100/100?random=16"),
        ("Papaya", "https://picsum.photos/100/100?random=17"),
        ("Quince", "https://picsum.photos/100/100?random=18"),
        ("Raspberry", "https://picsum.photos/100/100?random=19"),
        ("Strawberry", "https://picsum.photos/100/100?random=20"),
        ("Tangerine", "https://picsum.photos/100/100?random=21"),
        ("Ugli Fruit", "https://picsum.photos/100/100?random=22"),
        ("Watermelon", "https://picsum.photos/100/100?random=23"),
        ("Xigua", "https://picsum.photos/100/100?random=24"),
        ("Yellow Passion Fruit", "https://picsum.photos/100/100?random=25"),
        ("Zucchini", "https://picsum.photos/100/100?random=26")
    ]

    var filteredItems: [(String, String)] {
        if searchText.isEmpty {
            return itemsWithImages
        } else {
            return itemsWithImages.filter { $0.0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    // Images Carousel
                    TabView {
                        ForEach(images, id: \.self) { imageUrl in
                            AsyncImage(url: URL(string: imageUrl)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 250)
                                    .clipped()
                            } placeholder: {
                                Color.gray // Placeholder color while loading
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 250)
                    
                    // Search Bar
                    SearchBar(text: $searchText)
                        .background(Color.white)
                        .padding(.horizontal)
                        .padding(.top, 10) // Adjust top padding to fit within safe area
                        .background(
                            GeometryReader { geometry -> Color in
                                let offset = geometry.frame(in: .global).minY
                                DispatchQueue.main.async {
                                    if initialSearchBarOffset == nil {
                                        initialSearchBarOffset = offset
                                        print("Initial Search Bar Offset: \(initialSearchBarOffset ?? 0)")
                                    }
                                    
                                    searchBarOffset = offset
                                    
                                    if searchBarOffset <= (initialSearchBarOffset ?? 0) {
                                        if !isSearchBarStuck {
                                            print("Search bar is stuck at: \(searchBarOffset)")
                                        }
                                        isSearchBarStuck = true
                                    } else {
                                        if isSearchBarStuck {
                                            print("Search bar is unstuck at: \(searchBarOffset)")
                                        }
                                        isSearchBarStuck = false
                                    }
                                }
                                return Color.clear
                            }
                        )
                        .offset(y: isSearchBarStuck ? max(0, 44 - searchBarOffset) : 0) // Adjust offset for sticky behavior
                        .animation(.easeInOut, value: isSearchBarStuck)
                        .safeAreaInset(edge: .top, spacing: 0) {
                            Color.clear.frame(height: 55) // Adjust height to match search bar height
                        }
                    
                    // Scrollable List with Square Images on the Left
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(filteredItems, id: \.0) { item, imageUrl in
                            HStack(alignment: .center) {
                                AsyncImage(url: URL(string: imageUrl)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50) // Square image
                                        .cornerRadius(8)
                                        .clipped()
                                } placeholder: {
                                    Color.gray
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                }
                                
                                Text(item)
                                    .font(.headline)
                                    .padding(.leading, 10)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10) // Add padding to avoid overlap
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

// Search Bar Component
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.5), radius: 2, x: 0, y: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

