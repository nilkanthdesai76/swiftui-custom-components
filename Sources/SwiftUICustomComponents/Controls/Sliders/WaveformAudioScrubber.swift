import SwiftUI
import Combine

public struct WaveformAudioScrubber: View {
    @Binding public var progress: Double // 0.0 to 1.0
    public var duration: TimeInterval // in seconds
    public var waveColor: Color
    public var playedColor: Color
    
    // Sample audio amplitudes (normalized 0.15 to 1.0)
    private let sampleAmplitudes: [CGFloat] = [
        0.25, 0.45, 0.7, 0.35, 0.85, 0.95, 0.6, 0.4, 0.8, 1.0,
        0.75, 0.5, 0.3, 0.65, 0.9, 0.8, 0.45, 0.6, 0.7, 0.85,
        0.55, 0.35, 0.65, 0.4
    ]
    
    public init(
        progress: Binding<Double>,
        duration: TimeInterval = 195, // 3:15
        waveColor: Color = Color.gray.opacity(0.3),
        playedColor: Color = .purple
    ) {
        self._progress = progress
        self.duration = duration
        self.waveColor = waveColor
        self.playedColor = playedColor
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                let barCount = sampleAmplitudes.count
                let spacing: CGFloat = 4
                let totalSpacing = spacing * CGFloat(barCount - 1)
                let barWidth = max(2, (width - totalSpacing) / CGFloat(barCount))
                
                ZStack(alignment: .leading) {
                    // Bars HStack
                    HStack(alignment: .center, spacing: spacing) {
                        ForEach(0..<barCount, id: \.self) { idx in
                            let amp = sampleAmplitudes[idx]
                            let barProgress = Double(idx) / Double(barCount)
                            let isPlayed = barProgress <= progress
                            
                            RoundedRectangle(cornerRadius: barWidth / 2)
                                .fill(isPlayed ? playedColor : waveColor)
                                .frame(width: barWidth, height: max(6, height * amp))
                                .animation(.spring(response: 0.25, dampingFraction: 0.7), value: progress)
                        }
                    }
                    .frame(width: width, height: height)
                    
                    // Scrubber Indicator Head
                    let scrubberX = width * CGFloat(progress)
                    Capsule()
                        .fill(Color.white)
                        .frame(width: 3, height: height + 6)
                        .shadow(color: playedColor.opacity(0.6), radius: 6)
                        .offset(x: max(0, min(width - 3, scrubberX)))
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            let newProgress = max(0, min(1, gesture.location.x / width))
                            if abs(newProgress - progress) >= 0.04 {
                                HapticFeedback.light()
                            }
                            progress = Double(newProgress)
                        }
                )
            }
            .frame(height: 48)
            
            // Time Labels
            HStack {
                Text(timeString(from: duration * progress))
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(playedColor)
                Spacer()
                Text(timeString(from: duration))
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func timeString(from seconds: TimeInterval) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
