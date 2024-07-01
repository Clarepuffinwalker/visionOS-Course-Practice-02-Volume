//
//  ContentView.swift
//  visionOS Course Practice 02 Volume
//
//  Created by Clare Zhou on 2024/7/1.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    // open new model window, model window states
    @State private var isWindowOpen = false
    // open portal, portal states
    @State private var isPortalOpen = false
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow

    var body: some View {
        VStack {
            HStack {
                Model3D(named: "pancakes")
                    .padding(.trailing, 100)
                
                let tulipURL = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/tulip/flower_tulip.usdz")!
                Model3D(url: tulipURL){ model in
                    model.resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
            }
            
            //1st row volumatric & portal window
            HStack{
                Toggle("Show Pavilion Model", isOn: $isWindowOpen)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .onChange(of:isWindowOpen){_,newValue in
                        if newValue {
                            openWindow(id:"pavilion")
                        }
                        else {
                            dismissWindow(id:"pavilion")
                        }
                    }
                    .toggleStyle(.button)
                
                
                Toggle("Show Portal", isOn: $isPortalOpen)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .onChange(of:isPortalOpen){_,newValue in
                        if newValue {
                            openWindow(id:"portal")
                        }
                        else {
                            dismissWindow(id:"portal")
                        }
                    }
                    .toggleStyle(.button)
            }
            
            
            Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
                .font(.title)
                .frame(width: 360)
                .padding(24)
                .glassBackgroundEffect()
        }
        .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }

        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
