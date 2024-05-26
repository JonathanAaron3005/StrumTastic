//
//  Chord.swift
//  test
//
//  Created by Jonathan Aaron Wibawa on 21/05/24.
//

import SwiftUI

class Chord: Identifiable {
    var id = UUID()
    var name: String
    var imageName: String
    
    private static var possibleChords = ["G", "F", "Em", "Dm", "C", "Bb", "Am"]
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
    
    static func getPossibleChord() -> String {
        return possibleChords.randomElement() ?? "G"
    }
    
    static func getDummyData() -> [Chord] {
        return [
            Chord(name: "C", imageName: "C"),
            Chord(name: "F", imageName: "F"),
            Chord(name: "G", imageName: "G"),
            Chord(name: "Am", imageName: "Am"),
            Chord(name: "Dm", imageName: "Dm"),
            Chord(name: "Bb", imageName: "Bb"),
            Chord(name: "Em", imageName: "Em")
        ]
    }
}

