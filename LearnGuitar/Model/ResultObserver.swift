import SwiftUI
import CoreML
import SoundAnalysis
import AVFoundation

class ResultsObserver: NSObject, SNResultsObserving {
    
    @Binding var classificationResult: String
    @Binding var expectedResult: String
    @Binding var message: String
    
    var audioPlayer: AVAudioPlayer?

    init(classificationResult: Binding<String>, expectedResult: Binding<String>, message: Binding<String>) {
        self._classificationResult = classificationResult
        self._expectedResult = expectedResult
        self._message = message
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else  { return }

        guard let classification = result.classifications.first else { return }

        let timeInSeconds = result.timeRange.start.seconds

        let formattedTime = String(format: "%.2f", timeInSeconds)
        print("Analysis result for audio at time: \(formattedTime)")

        let percent = classification.confidence * 100.0
        let percentString = String(format: "%.2f%%", percent)

        print("\(classification.identifier): \(percentString) confidence.\n")
        
        classificationResult = classification.identifier
        
        if classificationResult == expectedResult && percent > 75.0 {
            message = ""
            playSoundEffect()
            expectedResult = Chord.getPossibleChord()
        } else {
            message = "Try Again!"
        }
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The analysis failed: \(error.localizedDescription)")
    }

    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }

    func playSoundEffect() {
        guard let url = Bundle.main.url(forResource: "success", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 20.0
            audioPlayer?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}
