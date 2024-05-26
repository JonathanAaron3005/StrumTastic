//
//  CustomButton.swift
//  test
//
//  Created by Jonathan Aaron Wibawa on 24/05/24.
//

import SwiftUI

struct CustomButton: View {
    
    var text: String = ""
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
            .frame(width: 400, height: 90)
            .background(LinearGradient(gradient: text == "Start" ?
                                       Gradient(colors: [Color.green, Color.blue]) :
                                        Gradient(colors: [Color.red, Color.orange]),
                                       startPoint: .leading,
                                       endPoint: .trailing))
            .cornerRadius(45)
            .shadow(radius: 10)
    }
}

#Preview {
    CustomButton(text: "Start")
}
