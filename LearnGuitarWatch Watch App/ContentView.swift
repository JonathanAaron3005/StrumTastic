import SwiftUI

struct ContentView: View {
    @State private var timer: DispatchSourceTimer?
    @State private var bpm: Double = 40
    @State private var isPlaying = false
    
    var body: some View {
        VStack {
            Text("Metronome")
                .font(.title3)
                .padding()
            
            HStack {
                Button(action: {
                    decreaseBPM()
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding()
                }
                
                VStack {
                    Text("\(Int(bpm))")
                        .fontWeight(.bold)
                        .font(bpm < 100 ? .title3 : .system(size: 12))
                    Text("BPM")
                        .font(.system(size: 12))
                }
                .padding()
                
                Button(action: {
                    increaseBPM()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding()
                }
            }
            .padding()
            .simultaneousGesture(LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    self.increaseBPM()
                })
            
            Button(action: {
                if self.isPlaying {
                    self.stopMetronome()
                } else {
                    self.startMetronome()
                }
                self.isPlaying.toggle()
            }) {
                CustomButtonWatch(text: isPlaying ? "Stop" : "Start")
            }
            .padding()
        }
    }
    
    func increaseBPM() {
        if bpm < 240 {
            bpm += 1
        }
    }
    
    func decreaseBPM(){
        if bpm > 40 {
            bpm -= 1
        }
    }
    
    func startMetronome() {
        let interval = 60.0 / bpm
        let queue = DispatchQueue(label: "metronome.timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: interval)
        timer?.setEventHandler {
            self.playHaptic()
        }
        timer?.resume()
    }
    
    func stopMetronome() {
        timer?.cancel()
        timer = nil
    }
    
    func playHaptic() {
        WKInterfaceDevice.current().play(.click)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




