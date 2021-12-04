//
//  SwiftUIView.swift
//  
//
//  Created by Ostap on 04.12.2021.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct EditSoundView: View {
    @Binding var sound: Sound
    
    public var body: some View {
        List {
            Section(header: Text("Name")) {
                TextField(LocalizedStringKey("Name"), text: $sound.name)
            }
            
            Section(header: Text("URL")) {
                TextField(LocalizedStringKey("URL"), text: $sound.url)
            }
        }
    }
    
    public init(sound: Binding<Sound>) {
        _sound = sound
    }
}

#if DEBUG
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
struct EditSoundView_Previews: PreviewProvider {
    @State static var sound = Sound.exampleData[2]
    
    static var previews: some View {
        EditSoundView(sound: $sound)
    }
}
#endif

