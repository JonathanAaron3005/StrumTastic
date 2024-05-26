//
//  ChordLibrary.swift
//  LearnGuitar
//
//  Created by Jonathan Aaron Wibawa on 24/05/24.
//

import SwiftUI

struct ChordLibrary: View {
    let chords: [Chord] = Chord.getDummyData()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.85))
                .ignoresSafeArea(.all)
            ScrollView {
                Spacer()
                
                Text("Chord Library")
                    .font(.system(size: 45))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 40)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                
                LazyVGrid(columns: columns, spacing: 80) {
                    ForEach(chords) { chord in
                        VStack {
                            Text(chord.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Image(chord.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding()
            }
            .padding()
        }
    }
}

#Preview {
    ChordLibrary()
}
