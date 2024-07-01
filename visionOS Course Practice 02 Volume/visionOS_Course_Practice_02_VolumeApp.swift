//
//  visionOS_Course_Practice_02_VolumeApp.swift
//  visionOS Course Practice 02 Volume
//
//  Created by Clare Zhou on 2024/7/1.
//

import SwiftUI

@main
struct visionOS_Course_Practice_02_VolumeApp: App {
    
    @State private var currentImmersionStyle: ImmersionStyle = .progressive
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1200, maxWidth: 1500, minHeight: 720, maxHeight: 1500)
        }
        .windowResizability(.contentSize)
        
        
        WindowGroup(id:"pavilion"){
            PavilionView()
        }
        .windowStyle(.volumetric)
        //.defaultSize(width: 0.5, height: 0.3, depth: 1, in: .meters)

        WindowGroup(id:"portal")
        {
            PortalView()
        }
        .windowStyle(.volumetric)
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
        .immersionStyle(selection: $currentImmersionStyle, in: .mixed,.progressive,.full)
    }
}
