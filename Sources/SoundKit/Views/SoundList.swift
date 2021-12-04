//
//  SoundList.swift
//  
//
//  Created by Ostap on 04.12.2021.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, *)
public struct SoundList: View {
    @State var adding = false
    @ObservedObject var store: SoundStore
    @State var newSound = Sound(name: "", url: "")
    
    public var body: some View {
        NavigationView {
            List {
                if store.sounds.isEmpty {
                    Text("There are no sounds")
                }
                else {
                    ForEach($store.sounds) { $sound in
                        NavigationLink(
                            destination: EditSoundView(sound: $sound).navigationTitle(sound.name)
                        ) {
                            Text(sound.name)
                        }
                    }
                    .onDelete { indices in
                        store.sounds.remove(atOffsets: indices)
                    }
                }
            }
            .navigationTitle("Sounds")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        adding = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $adding) {
                NavigationView {
                    EditSoundView(sound: $newSound)
                        .navigationTitle("New sound")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancel") {
                                    adding = false
                                }
                            }
                            
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Add") {
                                    store.sounds.append(newSound)
                                    adding = false
                                }
                            }
                        }
                }
            }
        }
    }
    
    public init() {
        store = .init(sounds: Sound.exampleData)
    }
    
    public init(store: SoundStore) {
        self.store = store
    }
}

#if DEBUG
@available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, *)
struct SoundList_Previews: PreviewProvider {
    static var previews: some View {
        SoundList()
    }
}
#endif
