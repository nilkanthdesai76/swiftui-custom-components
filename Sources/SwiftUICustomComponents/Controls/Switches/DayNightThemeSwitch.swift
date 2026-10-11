import SwiftUI

/// An animated day/night theme toggle switch where the thumb transforms between a glowing sun and a cratered moon with starry night sky backgrounds.
public struct DayNightThemeSwitch: View {
    @Binding public var isNight: Bool
    
    public init(isNight: Binding<Bool>) {
        self._isNight = isNight
    }
    
    public var body: some View {
        Button {
            HapticFeedback.medium()
            withAnimation(.spring(response: 0.38, dampingFraction: 0.7)) {
                isNight.toggle()
            }
        } label: {
            ZStack(alignment: isNight ? .trailing : .leading) {
                // Track Background
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: isNight ? [
                                Color(red: 0.08, green: 0.08, blue: 0.18),
                                Color(red: 0.15, green: 0.12, blue: 0.30)
                            ] : [
                                Color(red: 0.35, green: 0.72, blue: 0.98),
                                Color(red: 0.55, green: 0.85, blue: 0.98)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 68, height: 36)
                    .overlay(
                        // Ambient stars or clouds
                        HStack {
                            if isNight {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white.opacity(0.6))
                                    .padding(.leading, 8)
                                Spacer()
                            } else {
                                Spacer()
                                Image(systemName: "cloud.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.trailing, 8)
                            }
                        }
                    )
                
                // Animated Thumb (Sun or Moon)
                ZStack {
                    Circle()
                        .fill(isNight ? Color(red: 0.90, green: 0.90, blue: 0.95) : Color(red: 1.0, green: 0.80, blue: 0.15))
                        .frame(width: 28, height: 28)
                        .shadow(color: isNight ? Color.purple.opacity(0.3) : Color.orange.opacity(0.4), radius: 4, y: 1)
                    
                    if isNight {
                        // Moon Craters
                        HStack(spacing: 2) {
                            Circle().fill(Color.gray.opacity(0.35)).frame(width: 5, height: 5).offset(x: -2, y: -3)
                            Circle().fill(Color.gray.opacity(0.35)).frame(width: 4, height: 4).offset(x: 2, y: 3)
                        }
                    } else {
                        // Sun Rays
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.85))
                            .rotationEffect(.degrees(isNight ? 180 : 0))
                    }
                }
                .padding(4)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DayNightThemeSwitch(isNight: .constant(false))
        .padding()
}
