import SwiftUI

struct DialView: View {
    let timerState: PomodoroTimerState
    let settings: PomodoroSettings
    let referenceDate: TimeInterval
    let accentColor: Color

    private var elapsed: TimeInterval {
        timerState.elapsed(at: referenceDate)
    }

    private var secondsFraction: Double {
        elapsed.truncatingRemainder(dividingBy: 60.0)
    }

    private var minutesFraction: Double {
        (elapsed / 60.0).truncatingRemainder(dividingBy: 60.0)
    }

    private var secondsRotation: Double {
        2 * .pi * (secondsFraction / 60.0)
    }

    private var minutesRotation: Double {
        2 * .pi * (minutesFraction / 60.0)
    }

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let minDimension = min(size.width, size.height)
            ZStack {
                backgroundCircle(minDimension: minDimension)
                dialCanvas(size: size, minDimension: minDimension)
                selectorWindows(size: size)
            }
            .frame(width: size.width, height: size.height)
        }
    }

    private func backgroundCircle(minDimension: CGFloat) -> some View {
        Circle()
            .fill(.linearGradient(
                colors: [Color.black, Color(red: 0.08, green: 0.08, blue: 0.12)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.12), lineWidth: minDimension * 0.015)
            )
    }

    private func dialCanvas(size: CGSize, minDimension: CGFloat) -> some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let outerRadius = minDimension * 0.48
            let minutesRadius = minDimension * 0.34

            drawSecondsRing(in: &context, center: center, radius: outerRadius)
            drawMinutesRing(in: &context, center: center, radius: minutesRadius)
            drawCenterReadout(in: &context, center: center, minDimension: minDimension)
        }
    }

    private func selectorWindows(size: CGSize) -> some View {
        let windowSize = min(size.width, size.height) * 0.22
        let cornerRadius = windowSize * 0.35

        return ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(Color.white.opacity(0.4), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(Color.white.opacity(0.08))
                )
                .frame(width: windowSize * 0.9, height: windowSize * 0.36)
                .position(x: windowSize * 0.5, y: size.height / 2)

            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(Color.white.opacity(0.4), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(Color.white.opacity(0.08))
                )
                .frame(width: windowSize * 0.9, height: windowSize * 0.36)
                .position(x: size.width - windowSize * 0.5, y: size.height / 2)
        }
        .allowsHitTesting(false)
    }

    private func drawSecondsRing(in context: inout GraphicsContext, center: CGPoint, radius: CGFloat) {
        let baseFont = Font.system(size: radius * 0.13, weight: .medium, design: .rounded)
        let highlightColor = accentColor

        for value in 0..<60 {
            let angle = (.pi + (Double(value) / 60.0) * (.pi * 2)) - secondsRotation
            let point = AngleMath.point(onCircleWithCenter: center, radius: radius, angle: angle)
            var text = Text(String(format: "%02d", value))
                .font(baseFont)
                .foregroundStyle(Color.white.opacity(0.8))

            if isCurrentSecond(value: value) {
                text = text.foregroundStyle(highlightColor)
            }

            context.draw(context.resolve(text), at: point, anchor: .center)
        }

        drawTicks(in: &context, center: center, radius: radius + 8, rotation: secondsRotation)
    }

    private func drawMinutesRing(in context: inout GraphicsContext, center: CGPoint, radius: CGFloat) {
        let baseFont = Font.system(size: radius * 0.16, weight: .semibold, design: .rounded)
        let baseColor = Color.white.opacity(0.9)

        for value in 0..<60 {
            let angle = ((Double(value) / 60.0) * (.pi * 2)) - minutesRotation
            let point = AngleMath.point(onCircleWithCenter: center, radius: radius, angle: angle)
            let text = Text(String(format: "%02d", value))
                .font(baseFont)
                .foregroundStyle(value == currentMinuteValue ? accentColor : baseColor.opacity(0.7))
            context.draw(context.resolve(text), at: point, anchor: .center)
        }
    }

    private func drawCenterReadout(in context: inout GraphicsContext, center: CGPoint, minDimension: CGFloat) {
        let remaining = timerState.remainingDuration(using: settings, at: referenceDate)
        let minutes = max(0, Int(remaining) / 60)
        let seconds = max(0, Int(remaining) % 60)

        let minutesText = Text(String(format: "%02d", minutes))
            .font(.system(size: minDimension * 0.22, weight: .bold, design: .rounded))
            .foregroundStyle(Color.white)

        let secondsText = Text(String(format: "%02d", seconds))
            .font(.system(size: minDimension * 0.1, weight: .semibold, design: .rounded))
            .foregroundStyle(Color.black)

        let minutesResolved = context.resolve(minutesText)
        let secondsResolved = context.resolve(secondsText)
    let maxMeasureSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)

        let minutesSize = minutesResolved.measure(in: maxMeasureSize)
        let secondsSize = secondsResolved.measure(in: maxMeasureSize)

        let spacing = minDimension * 0.04
        let secondsHorizontalPadding = minDimension * 0.06
        let secondsVerticalPadding = minDimension * 0.02
        let secondsBackgroundSize = CGSize(
            width: secondsSize.width + secondsHorizontalPadding * 2,
            height: secondsSize.height + secondsVerticalPadding * 2
        )

        let totalWidth = minutesSize.width + spacing + secondsBackgroundSize.width

        let minutesX = center.x - totalWidth / 2 + minutesSize.width / 2
        let minutesPoint = CGPoint(x: minutesX, y: center.y)

        let secondsBackgroundOriginX = center.x + totalWidth / 2 - secondsBackgroundSize.width
        let secondsBackgroundOriginY = center.y - secondsBackgroundSize.height / 2
        let secondsBackgroundRect = CGRect(
            origin: CGPoint(x: secondsBackgroundOriginX, y: secondsBackgroundOriginY),
            size: secondsBackgroundSize
        )

        let backgroundPath = Path(roundedRect: secondsBackgroundRect, cornerRadius: secondsBackgroundSize.height / 2)
        context.fill(backgroundPath, with: .color(accentColor))

        let secondsPoint = CGPoint(x: secondsBackgroundRect.midX, y: center.y)

        context.draw(minutesResolved, at: minutesPoint, anchor: .center)
        context.draw(secondsResolved, at: secondsPoint, anchor: .center)
    }

    private func drawTicks(in context: inout GraphicsContext, center: CGPoint, radius: CGFloat, rotation: Double) {
        let tickCount = 60
        let longTickLength = radius * 0.1
        let shortTickLength = radius * 0.05
        let tickColor = Color.white.opacity(0.3)

        for index in 0..<tickCount {
            let baseAngle = (.pi + (Double(index) / Double(tickCount)) * (2 * .pi)) - rotation
            let isMajor = Double(index).truncatingRemainder(dividingBy: 5) == 0
            let start = AngleMath.point(
                onCircleWithCenter: center,
                radius: radius - (isMajor ? longTickLength : shortTickLength),
                angle: baseAngle
            )
            let tip = AngleMath.point(onCircleWithCenter: center, radius: radius, angle: baseAngle)

            var path = Path()
            path.move(to: start)
            path.addLine(to: tip)
            context.stroke(path, with: .color(tickColor), lineWidth: Double(index).truncatingRemainder(dividingBy: 5) == 0 ? 2 : 1)
        }
    }

    private func isCurrentSecond(value: Int) -> Bool {
        let current = Int(secondsFraction.rounded(.down)) % 60
        return current == value
    }

    private var currentMinuteValue: Int {
        let totalRemaining = max(0, settings.duration(for: timerState.currentPhase) - elapsed)
        return Int(totalRemaining) / 60
    }
}
