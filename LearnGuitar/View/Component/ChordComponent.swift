//
//  ChordComponent.swift
//  LearnGuitar
//
//  Created by Jonathan Aaron Wibawa on 26/05/24.
//

import SwiftUI


struct ChordComponent: View {
    
    @Binding var chord: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.7))
                .frame(width: 200, height: 200)
                .shadow(radius: 10)
            
            Text(chord)
                .font(.system(size: 70))
                .fontWeight(.bold)
                .foregroundColor(.yellow)
        }
    }
}


