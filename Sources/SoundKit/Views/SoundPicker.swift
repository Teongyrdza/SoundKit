//
//  SoundPicker.swift
//  
//
//  Created by Ostap on 04.12.2021.
//

import SwiftUI
import AVKit
import StarUI

class PickerModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var playing = false
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playing = false
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct SoundPicker: View {
    @StateObject var model = PickerModel()
    @Binding var selection: SoundUnion
    let sounds: [Sound]?
    let builtinSounds: [BuiltinSound]
    
    @State var playing = false
    @State var player: AVAudioPlayer?
    
    func playSound() {
        model.playing = true
        player?.delegate = model
        player?.currentTime = .zero
        player?.play()
    }
    
    func stopSound() {
        model.playing = false
        player?.pause()
    }
    
    func view(for sound: SoundUnion, cell: ListPickerCell<SoundUnion>.Builder, play: @escaping () -> Void) -> some View {
        cell(sound.name, selected: selection == sound) {
            if selection != sound {
                stopSound()
                selection = sound
            }
            
            if model.playing {
                stopSound()
            }
            else {
                play()
            }
        }
    }
    
    func builtinSoundPicker(cell: ListPickerCell<SoundUnion>.Builder) -> some View {
        ForEach(builtinSounds) { sound in
            view(for: .builtin(sound), cell: cell) {
                player = sound.player()
                playSound()
            }
        }
    }
    
    public var body: some View {
        ListPicker(selection: $selection) { cell in
            if let sounds = sounds {
                Section(header: Text("Builtin sounds")) {
                    builtinSoundPicker(cell: cell)
                }
                
                Section(header: Text("Custom sounds")) {
                    ForEach(sounds) { sound in
                        view(for: .userCreated(sound), cell: cell) {
                            Task {
                                player = await sound.player()
                                playSound()
                            }
                        }
                    }
                }
            }
            else {
                builtinSoundPicker(cell: cell)
            }
        }
    }
    
    public init(selection: Binding<SoundUnion>, sounds: [Sound] = [], builtinSounds: [BuiltinSound] = []) {
        self._selection = selection
        self.sounds = sounds
        self.builtinSounds = builtinSounds
    }
    
    public init(selection: Binding<BuiltinSound>, sounds: [BuiltinSound]) {
        _selection = .init(get: { .builtin(selection.wrappedValue) }) {
            if case .builtin(let sound) = $0 {
                selection.wrappedValue = sound
            }
        }
        builtinSounds = sounds
        self.sounds = nil
    }
}

#if DEBUG
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
struct SoundPickerPreview: View {
    @State var selection: SoundUnion = .builtin(BuiltinSound(named: "Ding"))
    
    var body: some View {
        SoundPicker(selection: $selection, sounds: Sound.exampleData, builtinSounds: BuiltinSound.exampleData)
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
struct SoundPicker_Previews: PreviewProvider {
    static var previews: some View {
        SoundPickerPreview()
    }
}
#endif
