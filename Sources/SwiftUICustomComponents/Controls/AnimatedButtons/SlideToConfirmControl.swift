import SwiftUI
import Combine

public struct SlideToConfirmControl: View {
    @Binding public var isConfirmed: Bool
    public var title: String
    public var confirmedTitle: String
    public var trackColor: Color
    public var thumbColor: Color
    public var icon: String
    public var confirmedIcon: String
    public var onConfirm: () -> Void
    
    @State private var dragOffset: CGFloat = 0
    @State private var trackWidth: CGFloat = 0
    private let thumbSize: CGFloat = 52
    private let padding: CGFloat = 4
    
    public init(
        isConfirmed: Binding<Bool>,
        title: String = "Slide to Confirm",
        confirmedTitle: String = "Confirmed",
        trackColor: Color = Color.blue.opacity(0.15),
        thumbColor: Color = .blue,
        icon: String = "arrow.right",
        confirmedIcon: String = "checkmark",
        onConfirm: @escaping () -> Void = {}
    ) {
        self._isConfirmed = isConfirmed
        self.title = title
        self.confirmedTitle = confirmedTitle
        self.trackColor = trackColor
        self.thumbColor = thumbColor
        self.icon = icon
        self.confirmedIcon = confirmedIcon
        self.onConfirm = onConfirm
    }
    
    private var maxDragDistance: CGFloat {
        max(0, trackWidth - thumbSize - (padding * 2))
    }
    
    private var progress: CGFloat {
        guard maxDragDistance > 0 else { return 0 }
        return min(1, max(0, dragOffset / maxDragDistance))
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Background Track
                Capsule()
                    .fill(trackColor)
                    .overlay(
                        Capsule()
                            .stroke(thumbColor.opacity(0.3), lineWidth: 1)
                    )
                
                // Progress Fill Track
                Capsule()
                    .fill(thumbColor.opacity(0.25))
                    .frame(width: isConfirmed ? trackWidth : max(thumbSize + padding * 2, dragOffset + thumbSize + padding * 2))
                
                // Center Shimmering Text
                HStack(spacing: 6) {
                    Spacer()
                    if isConfirmed {
                        Image(systemName: confirmedIcon)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(thumbColor)
                        Text(confirmedTitle)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(thumbColor)
                    } else {
                        Text(title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.primary.opacity(Double(1.0 - progress * 0.7)))
                        
                        Image(systemName: "chevron.right.2")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(thumbColor.opacity(Double(1.0 - progress * 0.7)))
                    }
                    Spacer()
                }
                .padding(.horizontal, thumbSize)
                
                // Sliding Thumb Handle
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [thumbColor, thumbColor.opacity(0.85)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: thumbColor.opacity(0.4), radius: 8, x: 0, y: 3)
                    
                    Image(systemName: isConfirmed ? confirmedIcon : icon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isConfirmed ? 0 : Double(progress * 45)))
                }
                .frame(width: thumbSize, height: thumbSize)
                .padding(padding)
                .offset(x: isConfirmed ? maxDragDistance : dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            guard !isConfirmed else { return }
                            let proposed = value.translation.width
                            if proposed > 0 && proposed <= maxDragDistance {
                                dragOffset = proposed
                                if proposed > maxDragDistance * 0.5 {
                                    HapticFeedback.light()
                                }
                            }
                        }
                        .onEnded { value in
                            guard !isConfirmed else { return }
                            if dragOffset >= maxDragDistance * 0.85 {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                    dragOffset = maxDragDistance
                                    isConfirmed = true
                                }
                                HapticFeedback.success()
                                onConfirm()
                            } else {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) {
                                    dragOffset = 0
                                }
                                HapticFeedback.warning()
                            }
                        }
                )
            }
            .onAppear {
                trackWidth = geo.size.width
            }
            .onChange(of: geo.size.width) { newWidth in
                trackWidth = newWidth
            }
        }
        .frame(height: thumbSize + (padding * 2))
    }
}
