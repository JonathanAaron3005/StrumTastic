import SwiftUI
import AVFoundation

struct Metronome: View {
    @State private var timer: Timer?
    @State private var bpm: Double = 40
    @State private var isPlaying = false
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.85))
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("Metronome")
                    .font(.system(size: 45))
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                
                Spacer()
                
                Slider(value: $bpm, in: 40...240, step: 1)
                    .padding()
                    .accentColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.3))
                    )
                    .padding(.horizontal, 50)

                
                VStack {
                    Text("\(Int(bpm))")
                        .font(.system(size: 120))
                        .fontWeight(.bold)
                        .foregroundStyle(.yellow)
                    Text("BPM")
                        .font(.system(size: 60))
                }
                .foregroundColor(.white)
                .shadow(radius: 5)
                .padding()
                
                Spacer()
                Spacer()
                
                Button(action: {
                    if self.isPlaying {
                        self.stopMetronome()
                    } else {
                        self.startMetronome()
                    }
                    self.isPlaying.toggle()
                }) {
                    CustomButton(text: isPlaying ? "Stop" : "Start")
                }
                .padding(.vertical, 50)
                
            }
            .padding()
        }
        .onAppear(perform: prepareAudio)
    }
    
    func prepareAudio() {
        guard let url = Bundle.main.url(forResource: "metronome", withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Failed to initialize audio player: \(error.localizedDescription)")
        }
    }
    
    func startMetronome() {
        let interval = 60.0 / bpm
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.playSoundEffect()
        }
    }
    
    func stopMetronome() {
        timer?.invalidate()
        timer = nil
    }
    
    func playSoundEffect() {
        audioPlayer?.volume = 10.0
        audioPlayer?.play()
    }
}

struct Metronome_Previews: PreviewProvider {
    static var previews: some View {
        Metronome()
    }
}
