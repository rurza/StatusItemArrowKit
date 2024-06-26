//
//  ArrowView.swift
//  
//
//  Created by Adam on 23/05/2023.
//

import SwiftUI

struct ArrowView: View {
    let color: Color

    var body: some View {
        TimelineView(.animation(minimumInterval: 0.8)) { context in
            GeometryReader { proxy in
                let radius = round(proxy.size.width * 0.2)
                let lineWidth = round(proxy.size.width * 0.08)
                ZStack {
                    ArrowPath(radius: radius)
                        .fill(color)
                    ArrowPath(radius: radius)
                        .stroke(
                            .white,
                            style: StrokeStyle(
                                lineWidth: lineWidth,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                        .padding(lineWidth / 2 - 2)
                }
            }
            .offset(
                x: CGFloat(Int.random(in: -2...2)),
                y: CGFloat(Int.random(in: -2...2))
            )
            .animation(.easeInOut(duration: 1), value: context.date)
        }

    }
}

struct ArrowPath: Shape {
    let radius: CGFloat
    func path(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height

        return Path { path in
            path.move(to: CGPoint(x: radius, y: height))
            path.addArc(
                center: CGPoint(x: radius, y: height - radius),
                radius: radius,
                startAngle: .radians(Double.pi / 2),
                endAngle: .radians(Double.pi),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: 0, y: height * 0.24))

            path.addQuadCurve(
                to: CGPoint(x: width / 2, y: 0),
                control: CGPoint(x: 0, y: height * 0.18)
            )

            path.addQuadCurve(
                to: CGPoint(x: width, y: height * 0.24),
                control: CGPoint(x: width, y: height * 0.18)
            )

            path.addLine(to: CGPoint(x: width, y: height - radius))

            path.addArc(
                center: CGPoint(x: width - radius, y: height - radius),
                radius: radius,
                startAngle: .radians(0),
                endAngle: .radians(Double.pi / 2),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: radius, y: height))

            path.closeSubpath()
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ArrowView(color: .red)
            .frame(width: 40, height: 120)
            .padding(40)
            .background(.yellow)
    }
}
