//
//  ArrowView.swift
//  
//
//  Created by Adam on 23/05/2023.
//

import SwiftUI

struct ArrowView: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 0.8)) { context in
            GeometryReader { proxy in
                let radius = round(proxy.size.width * 0.2)
                let lineWidth = round(proxy.size.width * 0.05)
                ZStack {
                    ArrowPath(radius: radius)
                        .fill(.linearGradient(
                            stops: [
                                .init(color: .accentColor, location: 0),
                                .init(color: .blue, location: 0.5)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    ArrowPath(radius: radius)
                        .stroke(
                            .white,
                            style: StrokeStyle(
                                lineWidth: lineWidth,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                        .padding(lineWidth / 2 - 1)
                }
            }
            .offset(
                x: CGFloat(Int.random(in: -3...3)),
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

            path.addLine(to: CGPoint(x: width / 2, y: 0))

            path.addLine(to: CGPoint(x: width, y: height * 0.24))
            path.addArc(
                tangent1End: CGPoint(x: width + radius, y: height * 0.24),
                tangent2End: CGPoint(x: width, y: height * 0.24 + radius),
                radius: radius
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
        ArrowView()
            .frame(width: 140, height: 400)
            .padding(40)
            .background(.yellow)
    }
}
