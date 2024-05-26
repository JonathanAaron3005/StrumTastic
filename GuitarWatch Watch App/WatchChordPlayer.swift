import SwiftUI
import CoreML
import SoundAnalysis
import AVFoundation

struct WatchChordPlayer: View {
    @State private var defaultConfig = MLModelConfiguration()
    private var soundClassifier: GuitarChordClassifier2_
    private var classifySoundRequest: SNClassifySoundRequest

    @State var result: String = ""
    @State var observer: ResultsObserver!
    
    @State private var audioEngine: AVAudioEngine?
    @State private var inputBus: AVAudioNodeBus?
    @State private var inputFormat: AVAudioFormat?
    @State private var streamAnalyzer: SNAudioStreamAnalyzer?
    @State private var analysisQueue = DispatchQueue(label: "com.example.AnalysisQueue")
    
    @State var expectedChord: String
    
    init() {

        self.expectedChord = Chord.getPossibleChord()
        let config = MLModelConfiguration()
        
        do {
            let classifier = try GuitarChordClassifier2_(configuration: config)
            self.soundClassifier = classifier
            self.classifySoundRequest = try SNClassifySoundRequest(mlModel: classifier.model)
        } catch {
            fatalError("Failed to create classifier or classify sound request: \(error)")
        }
    }
    
    var body: some View {
        VStack {
            Text("Chord: \(expectedChord)")
                .font(.title)
                .padding()
            Text("Recorded: \(result)")
                .font(.title)
                .padding()
            Button{
                classifySound()
            }label: {
                Text("Start")
            }
        }
        .onAppear(){
            observer = ResultsObserver(classificationResult: $result, expectedResult: $expectedChord)
        }
    }
    
    func classifySound(){
        
        startAudioEngine()

        streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat!)
        
        do {
            try streamAnalyzer?.add(classifySoundRequest,
                                   withObserver: observer)
        } catch {
            fatalError("Failed: \(error)")
        }
        
        installAudioTap()
    }
    
    func startAudioEngine() {
        // Create a new audio engine.
        audioEngine = AVAudioEngine()
        
        // Get the native audio format of the engine's input bus.
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
        audioEngine?.inputNode.installTap(onBus: inputBus!,
                                         bufferSize: 8192,
                                         format: inputFormat,
                                         block: analyzeAudio(buffer:at:))
    }
    
    func analyzeAudio(buffer: AVAudioBuffer, at time: AVAudioTime) {
        analysisQueue.async {
            self.streamAnalyzer?.analyze(buffer,
                                        atAudioFramePosition: time.sampleTime)
        
    }
}

#Preview {
    WatchChordPlayer()
}
