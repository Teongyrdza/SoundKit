//
//  SoundPicker.swift
//  
//
//  Created by Ostap on 04.12.2021.
//

import SwiftUI
import AVKit
import StarUI

@available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
public struct SoundPicker: View {
    @Binding var selection: SoundUnion
    let sounds: [Sound]
    let builtinSounds: [BuiltinSound]
    
    @State var playing = false
    @State var player: AVAudioPlayer?
    
    func playSound() {
        playing = true
        player?.play()
    }
    
    func stopSound() {
        playing = false
        player?.pause()
    }
    
    func view(for sound: SoundUnion, play: @escaping () -> Void) -> some View {
        Text(sound.name)
            .onTapGesture {
                if selection != sound || !playing {
                    play()
                }
                else {
                    stopSound()
                }
                
                selection = sound
            }
            .if(selection == sound)
            .listRowBackground(Color.accentColor)
            .endif()
    }
    
    public var body: some View {
        List {
            Section("Builtin sounds") {
                ForEach(builtinSounds) { sound in
                    view(for: .builtin(sound)) {
                        player = sound.player()
                        playSound()
                    }
                }
            }
            
            Section("Custom sounds") {
                ForEach(sounds) { sound in
                    view(for: .userCreated(sound)) {
                        Task {
                            player = await sound.player()
                            playSound()
                        }
                    }
                }
            }
        }
    }
    
    public init(selection: Binding<SoundUnion>, sounds: [Sound] = [], builtinSounds: [BuiltinSound] = []) {
        self._selection = selection
        self.sounds = sounds
        self.builtinSounds = builtinSounds
    }
}

#if DEBUG
@available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
struct SoundPickerPreview: View {
    @State var selection: SoundUnion = .builtin(BuiltinSound.exampleData[0])
    
    var body: some View {
        SoundPicker(selection: $selection, sounds: Sound.exampleData, builtinSounds: BuiltinSound.exampleData)
    }
}

@available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
struct SoundPicker_Previews: PreviewProvider {
    static var previews: some View {
        SoundPickerPreview()
    }
}
#endif
