//
//  SignatureView.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/12/11.
//

import SwiftUI
import UIKit
import PencilKit

struct SignatureView: View {
    @State private var currentDrawing: Drawing = Drawing()
    @State private var drawings: [Drawing] = [Drawing]()
    @State private var color: Color = Color.black
    @State private var lineWidth: CGFloat = 3.0
    @State private var uiimage: UIImage? = nil
    @State private var rect: CGRect = .zero
    
    var body: some View {
            VStack(alignment: .center) {
                Text("Sign below")
                    .font(.title)
                
                DrawingControls(color: $color,
                                drawings: $drawings,
                                lineWidth: $lineWidth,
                                uiimage: $uiimage,
                                rect: $rect)
                
                DrawingPad(currentDrawing: $currentDrawing,
                           drawings: $drawings,
                           color: $color,
                           lineWidth: $lineWidth)
                    .background(RectGetter(rect: $rect))
                
                /*if self.uiimage != nil {
                    VStack() {
                        Text("Signature")
                        Image(uiImage: self.uiimage!)
                    }
                }*/
            }
    }
}

struct DrawingControls: View {
    @Binding var color: Color
    @Binding var drawings: [Drawing]
    @Binding var lineWidth: CGFloat
    @Binding var uiimage: UIImage?
    @Binding var rect: CGRect
    
    var body: some View {
        VStack() {
            HStack() {
                Button("Undo") {
                    if self.drawings.count > 0 {
                        self.drawings.removeLast()
                    }
                }
                .padding([.top, .bottom], 10)
                .padding([.leading, .trailing], 20)
                Spacer()
                
                Button("Clear") {
                    self.drawings = [Drawing]()
                }
                
                Spacer()
                
                Button("Save") {
                    self.saveImage()
                }
                .padding([.top, .bottom], 10)
                .padding([.leading, .trailing], 20)
            }
            
            /*HStack {
                Text("Line width")
                    .padding()
                Slider(value: $lineWidth, in: 1.0...10.0, step: 1.0)
                    .padding()
            }*/
        }
    }
    
    private func saveImage() {
        self.uiimage = UIApplication.shared.windows[0].rootViewController?.view.asImage(rect: self.rect)
    }
}

struct Drawing {
    var points: [CGPoint] = [CGPoint]()
}

struct DrawingPad: View {
    @Binding var currentDrawing: Drawing
    @Binding var drawings: [Drawing]
    @Binding var color: Color
    @Binding var lineWidth: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for drawing in self.drawings {
                    self.add(drawing: drawing, toPath: &path)
                }
                self.add(drawing: self.currentDrawing, toPath: &path)
            }
            .stroke(self.color, lineWidth: self.lineWidth)
                .background(Color(white: 0.95))
                .gesture(
                    DragGesture(minimumDistance: 0.1)
                        .onChanged({ (value) in
                            let currentPoint = value.location
                            if currentPoint.y >= 0 && currentPoint.y < geometry.size.height {
                                self.currentDrawing.points.append(currentPoint)
                            }
                        })
                        .onEnded({ (value) in
                            self.drawings.append(self.currentDrawing)
                            self.currentDrawing = Drawing()
                        })
            )
        }
        .frame(maxHeight: 300)
    }
    
    private func add(drawing: Drawing, toPath path: inout Path) {
        let points = drawing.points
        if points.count > 1 {
            for i in 0..<points.count-1 {
                let current = points[i]
                let next = points[i+1]
                path.move(to: current)
                path.addLine(to: next)
            }
        }
    }
    
}

struct RectGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { proxy in
            self.createView(proxy: proxy)
        }
    }

    func createView(proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = proxy.frame(in: .global)
        }

        return Rectangle().fill(Color.clear)
    }
}

extension UIView {
    func asImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

struct SignatureView_Previews: PreviewProvider {
    static var previews: some View {
        SignatureView()
    }
}
