//
//  ImmersiveView.swift
//  visionOS Course Practice 02 Volume
//
//  Created by Clare Zhou on 2024/7/1.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    //skybox var settings
    @State private var skybox = Entity()
    
    var body: some View {
        RealityView { content in
            
           // if let scene = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
           //     content.add(scene)
           // }
            
            guard let pavilion = try? await Entity(named:"Shell") else {
                return
            }
            let scaleFactor: Float = 1
            pavilion.scale = [scaleFactor, scaleFactor, scaleFactor]
            pavilion.position = [0,0,0]
            //pavilion position for 5cm thickness cast
            //pavilion.position = [-5,0,-15]
            pavilion.components.set(GroundingShadowComponent(castsShadow: true))
            content.add(pavilion)
            
            //IBL Lighting
            if let environment = try? EnvironmentResource.load(named: "PureLight"){
                print("Environment resource loaded successfully")
                pavilion.components[ImageBasedLightComponent.self] = .init(source:.single(environment),intensityExponent: 2.0)
                pavilion.components[ImageBasedLightReceiverComponent.self] = .init(imageBasedLight:pavilion)}
            else{
                print("No environment resource found")
            }
            
            //Skybox Settings, for texture and shape
            //Orignal UnlitMaterial Settings
            guard let resource = try? await TextureResource(named: "Light") else {
                print("Unable to load texture")
                return
            }
            var SkyboxOrignalMaterial = UnlitMaterial()
            SkyboxOrignalMaterial.color = .init(texture: .init(resource))
            //Skybox Sphere,x needs to be set as -1, for Mterial showing inside sphere, not out
            skybox.components.set(ModelComponent(
                mesh: .generateSphere(radius: 1000), materials: [SkyboxOrignalMaterial]))
            skybox.scale = .init(x: -1 * abs(skybox.scale.x),y:skybox.scale.y, z:skybox.scale.z )
            content.add(skybox)
            
        }
    }
}

#Preview(immersionStyle: .progressive) {
    ImmersiveView()
}
