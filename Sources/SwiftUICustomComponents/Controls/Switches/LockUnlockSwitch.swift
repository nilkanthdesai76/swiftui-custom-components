import SwiftUI

/// A security-themed toggle switch where the thumb transforms between an open and closed padlock with snapping shackle animation.
public struct LockUnlockSwitch: View {
    @Binding public var isLocked: Bool
    
    public init(isLocked: Binding<Bool>) {
        self._isLocked = isLocked
    }
    
    public var body: some View {
        Button {
            if isLocked {
                HapticFeedback.light()
            } else {
                HapticFeedback.medium()
            }
            withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                isLocked.toggle()
            }
        } label: {
            ZStack(alignment: isLocked ? .trailing : .leading) {
                // Track
                Capsule()
                    .fill(isLocked ? Color.red.opacity(0.85) : Color.green.opacity(0.85))
                    .frame(width: 64, height: 34)
                    .overlay(
                        HStack {
                            if isLocked {
                                Text("LOCK")
                                    .font(.system(size: 8, weight: .black, design: .monospaced))
                                    .foregroundColor(.white)
                                    .padding(.leading, 8)
                                Spacer()
                            } else {
                                Spacer()
                                Text("OPEN")
                                    .font(.system(size: 8, weight: .black, design: .monospaced))
                                    .foregroundColor(.white)
                                    .padding(.trailing, 8)
                            }
                        }
                    )
                
                // Padlock Thumb
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 26, height: 26)
                        .shadow(color: Color.black.opacity(0.15), radius: 4, y: 1)
                    
                    Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(isLocked ? .red : .green)
                        .rotationEffect(.degrees(isLocked ? 0 : -10))
                }
                .padding(4)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LockUnlockSwitch(isLocked: .constant(true))
        .padding()
}
