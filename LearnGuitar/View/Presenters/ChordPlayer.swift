import SwiftUI
import CoreML
import SoundAnalysis
import AVFoundation

struct ChordPlayer: View {
    @State private var defaultConfig = MLModelConfiguration()
    private var soundClassifier: GuitarChordClassifier3
    private var classifySoundRequest: SNClassifySoundRequest

    @State var result: String = ""
    @State var message: String = ""
    @State var observer: ResultsObserver!
    
    @State private var audioEngine: AVAudioEngine?
    @State private var inputBus: AVAudioNodeBus?
    @State private var inputFormat: AVAudioFormat?
    @State private var streamAnalyzer: SNAudioStreamAnalyzer?
    @State private var analysisQueue = DispatchQueue(label: "com.example.AnalysisQueue")
    
    @State var expectedChord: String
    @State private var isClassifying = false
    
    init() {
        self.expectedChord = Chord.getPossibleChord()
        let config = MLModelConfiguration()
        
        do {
            let classifier = try GuitarChordClassifier3(configuration: config)
            self.soundClassifier = classifier
            self.classifySoundRequest = try SNClassifySoundRequest(mlModel: classifier.model)
        } catch {
            fatalError("Failed to create classifier or classify sound request: \(error)")
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.85))
                .ignoresSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer()
                
                Text("Play The Chord!")
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.primary)
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text("Expected Chord:")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    ChordComponent(chord: $expectedChord)
                        .padding(.bottom, 30)
                    
                    Text("Recorded:")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    ChordComponent(chord: $result)
                        .padding(.bottom, 30)
                }
                .padding(.top, 30)
                
                Text(message)
                    .foregroundStyle(.red)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    if isClassifying {
                        stopClassifySound()
                    } else {
                        classifySound()
                    }
                    isClassifying.toggle()
                }) {
                    CustomButton(text: isClassifying ? "Stop" : "Start")
                }
                .padding(.vertical, 50)
            }
            .padding()
            .onAppear() {
                observer = ResultsObserver(classificationResult: $result, expectedResult: $expectedChord, message: $message)
        }
        }
    }
    
    func classifySound() {
        startAudioEngine()
        streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat!)
        
        do {
            try streamAnalyzer?.add(classifySoundRequest, withObserver: observer)
        } catch {
            fatalError("Failed: \(error)")
        }
        
        installAudioTap()
    }
    
    func stopClassifySound() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: inputBus!)
        streamAnalyzer = nil
        result = ""
    }
    
    func startAudioEngine() {
        audioEngine = AVAudioEngine()
        inputBus = AVAudioNodeBus(0)
        
        guard let format = audioEngine?.inputNode.inputFormat(forBus: inputBus!) else {
            print("error")
            return
        }
        inputFormat = format
        
        do {
            try audioEngine?.start()
        } catch {
            print("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
    }
    
    func installAudioTap() {
        audioEngine?.inputNode.installTap(onBus: inputBus!, bufferSize: 8192, format: inputFormat, block: analyzeAudio(buffer:at:))
    }
    
    func analyzeAudio(buffer: AVAudioBuffer, at time: AVAudioTime) {
        analysisQueue.async {
            self.streamAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
        }
    }
}

#Preview {
    ChordPlayer()
}
