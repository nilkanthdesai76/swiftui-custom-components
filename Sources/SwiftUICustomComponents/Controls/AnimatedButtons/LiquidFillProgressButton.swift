import SwiftUI

/// A hold-to-confirm button where liquid progress rises as the user presses down, preventing accidental triggers.
public struct LiquidFillProgressButton: View {
    public let title: String
    public let completedTitle: String
    public var fillColor: Color
    public var duration: Double
    public var onComplete: () -> Void
    
    @State private var progress: Double = 0
    @State private var isPressing: Bool = false
    @State private var isFinished: Bool = false
    @State private var timer: Timer?
    
    public init(
        title: String = "Hold to Confirm",
        completedTitle: String = "Confirmed!",
        fillColor: Color = .green,
        duration: Double = 1.2,
        onComplete: @escaping () -> Void
    ) {
        self.title = title
        self.completedTitle = completedTitle
        self.fillColor = fillColor
        self.duration = duration
        self.onComplete = onComplete
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Background Track
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.primary.opacity(0.08))
                
                // Rising Liquid Fill
                RoundedRectangle(cornerRadius: 16)
                    .fill(fillColor)
                    .frame(width: geo.size.width * CGFloat(progress))
                    .animation(.linear(duration: 0.05), value: progress)
                
                // Content Label
                HStack(spacing: 8) {
                    if isFinished {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16, weight: .bold))
                    }
                    Text(isFinished ? completedTitle : title)
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(progress > 0.4 ? .white : .primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isPressing ? fillColor.opacity(0.5) : Color.primary.opacity(0.1), lineWidth: 1.5)
            )
            .scaleEffect(isPressing ? 0.98 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressing)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressing && !isFinished {
                            startFilling()
                        }
                    }
                    .onEnded { _ in
                        if !isFinished {
                            stopFilling()
                        }
                    }
            )
        }
        .frame(height: 52)
    }
    
    private func startFilling() {
        isPressing = true
        HapticFeedback.light()
        
        let interval = 0.02
        let step = interval / duration
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { t in
            if progress < 1.0 {
                progress += step
            } else {
                t.invalidate()
                isFinished = true
                isPressing = false
                HapticFeedback.success()
                onComplete()
            }
        }
    }
    
    private func stopFilling() {
        isPressing = false
        timer?.invalidate()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            progress = 0
        }
    }
}

#Preview {
    LiquidFillProgressButton(title: "Hold to Deploy", fillColor: .blue) {}
        .padding()
}
