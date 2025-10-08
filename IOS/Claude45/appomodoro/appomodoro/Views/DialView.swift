//
//  DialView.swift
//  appomodoro
//
//  Created by JOSE ZARABANDA on 10/8/25.
//

import SwiftUI

/// Main dial view with two concentric rotating number rings and fixed selector windows
struct DialView: View {
    let timerState: PomodoroTimerState
    let remaining: TimeInterval
    let accentColor: Color
    
    var body: some View {
        TimelineView(.animation(paused: !timerState.isRunning)) { timeline in
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius = min(size.width, size.height) / 2 - 40
                
                // Calculate current elapsed time based on timeline for smooth animation
                let now = timeline.date.timeIntervalSinceReferenceDate
                let animatedElapsed = timerState.elapsed(at: now)
                
                // Draw outer ticks (60 ticks for seconds)
                drawOuterTicks(context: context, center: center, radius: radius)
                
                // Draw inner ticks (lighter, for minutes reference)
                drawInnerTicks(context: context, center: center, radius: radius * 0.75)
                
                // Calculate rotation angles
                let thetaSeconds = AngleMath.secondsAngle(elapsed: animatedElapsed)
                let thetaMinutes = AngleMath.minutesAngle(elapsed: animatedElapsed)
                
                // Draw seconds ring (outer) with rotation
                drawSecondsRing(
                    context: context,
                    center: center,
                    radius: radius,
                    angle: thetaSeconds,
                    accentColor: accentColor
                )
                
                // Draw minutes ring (inner) with rotation
                drawMinutesRing(
                    context: context,
                    center: center,
                    radius: radius * 0.75,
                    angle: thetaMinutes,
                    accentColor: accentColor
                )
                
                // Draw fixed selector windows AFTER rings
                drawSelectorWindows(
                    context: context,
                    center: center,
                    radius: radius,
                    accentColor: accentColor
                )
                
                // Draw center readout
                drawCenterReadout(
                    context: context,
                    center: center,
                    remaining: remaining,
                    accentColor: accentColor
                )
            }
            .background(Color(white: 0.08)) // Dark graphite background
        }
    }
    
    // MARK: - Drawing Functions
    
    private func drawOuterTicks(context: GraphicsContext, center: CGPoint, radius: CGFloat) {
        for i in 0..<60 {
            let angle = -Double.pi / 2 + Double(i) * (2 * Double.pi / 60)
            let isLong = i % 5 == 0
            let innerRadius = radius - (isLong ? 15 : 8)
            let outerRadius = radius
            
            let innerPoint = AngleMath.pointOnCircle(angle: angle, radius: innerRadius, center: center)
            let outerPoint = AngleMath.pointOnCircle(angle: angle, radius: outerRadius, center: center)
            
            var path = Path()
            path.move(to: innerPoint)
            path.addLine(to: outerPoint)
            
            context.stroke(
                path,
                with: .color(.white.opacity(isLong ? 0.6 : 0.3)),
                lineWidth: isLong ? 2 : 1
            )
        }
    }
    
    private func drawInnerTicks(context: GraphicsContext, center: CGPoint, radius: CGFloat) {
        for i in 0..<60 {
            let angle = -Double.pi / 2 + Double(i) * (2 * Double.pi / 60)
            let isLong = i % 5 == 0
            let innerRadius = radius - (isLong ? 12 : 6)
            let outerRadius = radius
            
            let innerPoint = AngleMath.pointOnCircle(angle: angle, radius: innerRadius, center: center)
            let outerPoint = AngleMath.pointOnCircle(angle: angle, radius: outerRadius, center: center)
            
            var path = Path()
            path.move(to: innerPoint)
            path.addLine(to: outerPoint)
            
            context.stroke(
                path,
                with: .color(.white.opacity(isLong ? 0.3 : 0.15)),
                lineWidth: isLong ? 1.5 : 0.8
            )
        }
    }
    
    private func drawSecondsRing(context: GraphicsContext, center: CGPoint, radius: CGFloat, angle: Double, accentColor: Color) {
        // Draw all 60 second numbers around the ring
        // The ring rotates by 'angle', so we add that to each number's base position
        for i in 0..<60 {
            // Base angle for this number (evenly spaced around circle)
            let baseAngle = Double(i) * (2 * Double.pi / 60)
            // Apply rotation to simulate ring turning
            let displayAngle = baseAngle + angle
            
            let textRadius = radius - 30
            let position = AngleMath.pointOnCircle(angle: displayAngle, radius: textRadius, center: center)
            
            let text = String(format: "%02d", i)
            let textView = Text(text)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(i % 5 == 0 ? Color.white : Color.white.opacity(0.5))
            
            context.draw(textView, at: position)
        }
    }
    
    private func drawMinutesRing(context: GraphicsContext, center: CGPoint, radius: CGFloat, angle: Double, accentColor: Color) {
        // Draw all 60 minute numbers around the ring
        // The ring rotates by 'angle', so we add that to each number's base position
        for i in 0..<60 {
            // Base angle for this number (evenly spaced around circle)
            let baseAngle = Double(i) * (2 * Double.pi / 60)
            // Apply rotation to simulate ring turning
            let displayAngle = baseAngle + angle
            
            let textRadius = radius - 30
            let position = AngleMath.pointOnCircle(angle: displayAngle, radius: textRadius, center: center)
            
            let text = String(format: "%02d", i)
            let textView = Text(text)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(i % 5 == 0 ? Color.white.opacity(0.9) : Color.white.opacity(0.4))
            
            context.draw(textView, at: position)
        }
    }
    
    private func drawSelectorWindows(context: GraphicsContext, center: CGPoint, radius: CGFloat, accentColor: Color) {
        // LEFT selector window for seconds (outer ring)
        let leftWindowRect = CGRect(
            x: center.x - radius - 50,
            y: center.y - 20,
            width: 60,
            height: 40
        )
        let leftPath = RoundedRectangle(cornerRadius: 8)
            .path(in: leftWindowRect)
        
        context.stroke(
            leftPath,
            with: .color(accentColor),
            lineWidth: 2
        )
        
        // RIGHT selector window for minutes (inner ring)
        let rightWindowRect = CGRect(
            x: center.x + radius - 10,
            y: center.y - 20,
            width: 60,
            height: 40
        )
        let rightPath = RoundedRectangle(cornerRadius: 8)
            .path(in: rightWindowRect)
        
        context.stroke(
            rightPath,
            with: .color(accentColor),
            lineWidth: 2
        )
    }
    
    private func drawCenterReadout(context: GraphicsContext, center: CGPoint, remaining: TimeInterval, accentColor: Color) {
        let formatted = AngleMath.formatTime(remaining)
        
        // Large minutes display on left
        let minutesText = Text(formatted.minutes)
            .font(.system(size: 56, weight: .bold, design: .rounded))
            .foregroundStyle(Color.white)
        
        // Small seconds badge on right
        let secondsText = Text(formatted.seconds)
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .foregroundStyle(accentColor)
        
        // Position minutes slightly to the left
        let minutesPosition = CGPoint(x: center.x - 30, y: center.y)
        context.draw(minutesText, at: minutesPosition)
        
        // Position seconds badge to the right
        let secondsPosition = CGPoint(x: center.x + 40, y: center.y)
        
        // Draw oval background for seconds
        let ovalRect = CGRect(
            x: secondsPosition.x - 25,
            y: secondsPosition.y - 18,
            width: 50,
            height: 36
        )
        let ovalPath = Capsule()
            .path(in: ovalRect)
        
        context.fill(
            ovalPath,
            with: .color(accentColor.opacity(0.2))
        )
        context.stroke(
            ovalPath,
            with: .color(accentColor),
            lineWidth: 1.5
        )
        
        context.draw(secondsText, at: secondsPosition)
    }
}

#Preview {
    let state = PomodoroTimerState(
        currentPhase: .focus,
        isRunning: true,
        startedAt: Date().timeIntervalSinceReferenceDate - 125.5,
        accumulatedPause: 0,
        lastPausedElapsed: 0,
        completedFocusCycles: 0
    )
    
    return DialView(
        timerState: state,
        remaining: 1375.5,
        accentColor: .red
    )
    .frame(width: 400, height: 400)
}
