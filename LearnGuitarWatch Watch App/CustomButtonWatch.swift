import SwiftUI

struct CustomButtonWatch: View {
    
    var text: String = ""
    
    var body: some View {
        Text(text)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
            .frame(width: 175, height: 50)
            .background(LinearGradient(gradient: text == "Start" ?
                                        Gradient(colors: [Color.green, Color.blue]) :
                                        Gradient(colors: [Color.red, Color.orange]),
                                        startPoint: .leading,
                                        endPoint: .trailing))
            .cornerRadius(30)
            .shadow(radius: 5)
    }
}

struct CustomButtonWatch_Previews: PreviewProvider {
    static var previews: some View {
        CustomButtonWatch(text: "Start")
    }
}
