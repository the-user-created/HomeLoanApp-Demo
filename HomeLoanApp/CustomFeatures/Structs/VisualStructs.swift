//
//  VisualStructs.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/02/09.
//

import SwiftUI

// MARK: - TextFieldAlert
struct TextFieldAlert<Presenting>: View where Presenting: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isShowing: Bool
    @Binding var text: String
    
    @State var isPasswordAlert: Bool = false
    @State private var showPassword: Bool = false
    
    let presenting: Presenting
    let title: String

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                presenting
                    .disabled(isShowing)
                    .blur(radius: isShowing ? 3 : 0)
                
                VStack {
                    Text(title)
                        .font(.title2)
                    
                    Divider()
                    
                    if isPasswordAlert {
                        PasswordTextField(showPassword: $showPassword,
                                          password: $text,
                                          textColor: colorScheme == .dark ? .black : .white)
                            .padding()
                            .background(Capsule().fill(colorScheme == .dark ? Color.white : Color.black))
                    } else {
                        TextField("", text: $text)
                    }
                    
                    Divider()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            BackgroundForButton(btnText: "OK", btnColor: .blue)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                .padding()
                .background(colorScheme == .dark ? Color.black : Color.white)
                .opacity(isShowing ? 1 : 0)
                .frame(width: geometry.size.width*0.9)
                .foregroundColor(Color.primary)
                .cornerRadius(20)
            }
        }
    }

}


// MARK: - ActivityIndicator
struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}


// MARK: - LoadingView
struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                
                content()
                    .disabled(isShowing)
                    .blur(radius: isShowing ? 3 : 0)

                VStack {
                    Text("Loading...")
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(isShowing ? 1 : 0)
            }
        }
    }

}


// MARK: - BackgroundForButton
struct BackgroundForButton: View {
    
    var btnText: String
    var fWidth: CGFloat = 140
    var fHeight: CGFloat = 50
    var btnColor: Color = .blue
    
    var body: some View {
        HStack {
            Text(btnText)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: fWidth, height: fHeight)
                .background(btnColor)
                .clipped()
                .cornerRadius(5.0)
                .shadow(color: btnColor, radius: 5, x: 0, y: 5)
            
        }
    }
}


// MARK: - RichText
struct RichText: View {

    struct Element: Identifiable {
        let id = UUID()
        let content: String
        let isBold: Bool

        init(content: String, isBold: Bool) {
            var content = content.trimmingCharacters(in: .whitespacesAndNewlines)

            if isBold {
                content = content.replacingOccurrences(of: "*", with: "")
            }

            self.content = content
            self.isBold = isBold
        }
    }

    let elements: [Element]

    init(_ content: String) {
        elements = content.parseRichTextElements()
    }

    var body: some View {
        var content = text(for: elements.first!)
        elements.dropFirst().forEach { (element) in
            content = content + text(for: element)
        }
        return content
    }

    private func text(for element: Element) -> Text {
        let postfix = shouldAddSpace(for: element) ? " " : ""
        if element.isBold {
            return Text(element.content + postfix)
                .fontWeight(.bold)
        } else {
            return Text(element.content + postfix)
        }
    }

    private func shouldAddSpace(for element: Element) -> Bool {
        element.id != elements.last?.id
    }
}


// MARK: - ShakeEffect
struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 6
    var numOfShakes: CGFloat = 4
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(translationX: travelDistance * sin(animatableData * .pi * numOfShakes), y: 0)
        )
    }
}


// MARK: - GeometryGetter
struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                DispatchQueue.main.async {
                    self.rect = geometry.frame(in: .global)
                }

                return AnyView(Color.clear)
            }
        }
    }
}
