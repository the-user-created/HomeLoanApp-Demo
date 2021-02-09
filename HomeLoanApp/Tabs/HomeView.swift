//
//  HomeView.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/09/23.
//

import SwiftUI
//import Firebase

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var orientation = UIDevice.current.orientation.isLandscape.description
    @State var viewLoaded: Bool = false
    @State var screenWidth = UIScreen.main.bounds.size.width
    @State var screenHeight = UIScreen.main.bounds.size.height
    @State var imagePadding: CGFloat = 0
    
    let orientationPub = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
    let scale: CGFloat = UIScreen.main.scale
    
    init() {
        orientation = UIDevice.current.orientation.isLandscape.description
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        _imagePadding = State(wrappedValue: (scale == 2.0 ? 350 : 450) - screenHeight)
    }
    
    var body: some View {
        ZStack {
            Group {
                Image("LSImage")
                    .resizable()
                    .ignoresSafeArea(.all)
                
                Image("LSLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth - 60)
                    .animation(.timingCurve(0.65, 0.0, 0.25, 0.75, duration: 2.0))
                    .padding(.top, viewLoaded ? imagePadding : 30)
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                Text("Start Here")
                    .foregroundColor(.white)
                    .font(.title)
                
                Image("DownArrow")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 80)
                    .foregroundColor(Color.init(hex: "41702b"))
            }
            .animation(.timingCurve(0.65, 0.0, 0.25, 0.75, duration: 2.0))
            .padding(.bottom, viewLoaded ? 10 : -150)
        }
        .onAppear {
            self.viewLoaded = true
        }
        .onReceive(orientationPub) { _ in
            orientation = UIDevice.current.orientation.isLandscape.description
            screenWidth = UIScreen.main.bounds.size.width
            screenHeight = UIScreen.main.bounds.size.height
            imagePadding = (scale == 2.0 ? 350 : 450) - screenHeight
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 12 Pro")
            .preferredColorScheme(.dark)
    }
}
