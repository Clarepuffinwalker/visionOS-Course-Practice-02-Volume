//
//  PortalView.swift
//  visionOS Course Practice 02 Volume
//
//  Created by Clare Zhou on 2024/7/1.
//

import SwiftUI
import RealityKit

struct PortalView: View {
    var body: some View {
        RealityView { content in
            print("Initializing RealityView content...")
            let world = makeWorld()
            let portal = makePortal(world:world)
            
            content.add(world)
            content.add(portal)
            print("Added world and portal to content.")
        }
    }
    
    public func makeWorld() -> Entity{
        let world = Entity()
        world.components[WorldComponent.self] = .init()
        print("Created world entity.")
        
            // List all available resources,check why IBL image might not be loading
                            let bundle = Bundle.main
                            if let resourcePath = bundle.resourcePath {
                                do {
                                    let contents = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                                    print("Bundle Contents: \(contents)")
                                } catch {
                                    print("Failed to list bundle contents: \(error.localizedDescription)")
                                }
                            }
        
        //IBL Lighting
        if let environment = try? EnvironmentResource.load(named: /*"Light"*/ "PureLight"){
            print("Environment resource loaded successfully")
            world.components[ImageBasedLightComponent.self] = .init(source: .single(environment),intensityExponent: 5.0)
            world.components[ImageBasedLightReceiverComponent.self] = .init(imageBasedLight: world)
        } else {
            print("No environment resource found")
        }
        
        //3D Objects
        if let food = try? Entity.load(named: "pancakes") {
            print("food loaded successfully")
            food.position = [0,0,0]
            world.addChild(food)
        } else {
            print ("food not found")
        }
        return world
    }
    
    public func makePortal(world:Entity) -> Entity{
        let portal = Entity()
        
        portal.components[ModelComponent.self] = .init(mesh: .generatePlane(width:0.5, height: 0.5, cornerRadius:0.5), materials: [PortalMaterial()])
        portal.components[PortalComponent.self] = .init(target: world)
        
        print("Created portal entity.")
        
        return portal
    }
}

#Preview {
    PortalView()
}
