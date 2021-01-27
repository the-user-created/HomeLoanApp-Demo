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
    @State private var rect: CGRect = .zero
    @State var signatureSaved: Bool = false
    @State var loanID: String? = ""
    @Binding var signatureDone: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            HStack() {
                Text("Sign below")
                    .font(.title)
                
                Image(systemName: signatureDone ? "checkmark.circle.fill" : "checkmark.circle")
                    .foregroundColor(signatureDone ? .green : .red)
                    .padding(.leading, 10)
            }
            
            DrawingControls(color: $color,
                            drawings: $drawings,
                            lineWidth: $lineWidth,
                            rect: $rect,
                            signatureSaved: $signatureSaved,
                            loanID: loanID ?? "")
            
            DrawingPad(currentDrawing: $currentDrawing,
                       drawings: $drawings,
                       color: $color,
                       lineWidth: $lineWidth)
                .background(RectGetter(rect: $rect))
        }
        .onChange(of: drawings.isEmpty) { value in
            if signatureSaved {
                signatureDone = true
            } else {
                signatureDone = false
            }
        }
    }
}

struct DrawingControls: View {
    @Binding var color: Color
    @Binding var drawings: [Drawing]
    @Binding var lineWidth: CGFloat
    @Binding var rect: CGRect
    @Binding var signatureSaved: Bool
    @State var loanID: String
    
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
                
                Button(action: {
                    signatureSaved = true
                    self.saveImage("signature_\(loanID)_image.png") // Saves the signature png
                    self.drawings = [Drawing]() // Clears the drawing pad
                }) {
                    Text("Save")
                }
                .disabled(drawings.isEmpty)
                .foregroundColor(drawings.isEmpty ? .gray : .blue)
                .padding([.top, .bottom], 10)
                .padding([.leading, .trailing], 20)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
    func saveImage(_ signatureName: String) {
        if let signature = UIApplication.shared.windows[0].rootViewController?.view.asImage(rect: self.rect) {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

            let fileURL = documentsDirectory.appendingPathComponent(signatureName)
            guard let data = signature.pngData() else { return }
            
            // Checks if file exists, removes it if so.
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                    print("print - Removed old signature")
                } catch let removeError {
                    print("print - Couldn't remove signature at path", removeError)
                }

            }
            
            // Writes the image to the directory
            do {
                try data.write(to: fileURL)
                print("print - Added signature to directory: \(fileURL)")
            } catch let error {
                print("print - Error saving signature with error", error)
            }
        }
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
