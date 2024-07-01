//
//  PavilionView.swift
//  visionOS Course Practice 02 Volume
//
//  Created by Clare Zhou on 2024/7/1.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct PavilionView: View {
    
    var body: some View{
        VStack{
            RealityView {content, attachments in
                    guard let pavilion = try? await Entity(named:"10cmSmall") else {
                        print("Model not loaded.")
                        return
                    }
                    let scaleFactor: Float = 0.05
                    pavilion.scale = [scaleFactor, scaleFactor, scaleFactor]
                pavilion.position = [0.25,-0.3,-0.35]
                    content.add(pavilion)
                    print("Model added successfully.")
                
                    if let pavilionTag = attachments.entity(for:"pavilion-tag") {
                        pavilionTag.position = [-5,-1,13]
                        pavilionTag.scale = [1/scaleFactor,1/scaleFactor,1/scaleFactor]
                        pavilion.addChild(pavilionTag)
                        
                        //IBL Lighting
                        if let environment = try? EnvironmentResource.load(named: "PureLight"){
                            print("Environment resource loaded successfully")
                            pavilion.components[ImageBasedLightComponent.self] = .init(source:.single(environment),intensityExponent: 0.2)
                            pavilion.components[ImageBasedLightReceiverComponent.self] = .init(imageBasedLight:pavilion)}
                        else{
                            print("No environment resource found")
                        }
                }
            }
            
        attachments:{
            Attachment(id: "pavilion-tag"){
                Text("Concrete Cast Pavilion - Shell Structure")
                    .font(.title)
                    .padding()
                    .glassBackgroundEffect()
            }
        }
            
        }
    }
}
        

#Preview(windowStyle:.volumetric) {
    PavilionView()
}
