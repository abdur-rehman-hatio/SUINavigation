//
//  NavigationStorageActionItemView.swift
//
//
//  Created by Sergey Balalaev on 13.11.2023.
//

import SwiftUI

struct NavigationStorageActionItemView<Destination: View>: View {
    let isActive: Binding<Bool>
    let identifier: String
    let param: NavigationParameter?

    @State
    private var uid: String? = nil

    // `.navigation(isActive:id:destination:)` (the only public entry point that creates this
    // view) is only ever meaningful inside a `NavigationStorageView`'s content, where
    // `NavigationStorage` is unconditionally present in the environment. We previously used
    // `@OptionalEnvironmentObject`, which detects presence via `Mirror` reflection into
    // `@EnvironmentObject`'s private internal storage — an undocumented implementation detail
    // of the SwiftUI framework binary shipped with a given OS release, which can (and evidently
    // does, on some iOS 14 devices) differ enough that the presence check spuriously reports
    // `false`, silently skipping `addItem`/`removeItem` and permanently desyncing `pathItems`
    // from the actual navigation stack. Using a direct `@EnvironmentObject` here removes that
    // dependency entirely in favor of SwiftUI's own first-party (and reliably cross-version)
    // environment object mechanism.
    @EnvironmentObject
    private var navigationStorage: NavigationStorage

    private var isNavigationStackUsed: Binding<Bool>

    init(isNavigationStackUsed: Binding<Bool>, isActive: Binding<Bool>, identifier: String, param: NavigationParameter? = nil) {
        self.isActive = isActive
        self.identifier = identifier
        self.param = param
        self.isNavigationStackUsed = isNavigationStackUsed
    }

    var body: some View {
        // Deliberately not `EmptyView()`: SwiftUI can skip mounting/tracking `EmptyView()`
        // since it has no real content, which on some iOS 14 SwiftUI runtimes means
        // `.onChange` attached to it never fires at all — silently breaking `addItem`
        // registration and permanently desyncing `pathItems` from the actual push. A
        // zero-sized `Color.clear` is real (invisible) content, so it stays reliably mounted.
        Color.clear
            .frame(width: 0, height: 0)
            .onChange(of: isActive.wrappedValue) { newValue in
                if newValue {
                    uid = navigationStorage.addItem(isPresented: isActive, id: identifier, viewType: Destination.navigationID.stringValue, param: param)
                } else {
                    navigationStorage.removeItem(isPresented: isActive, id: identifier, uid: uid)
                }
            }
            .onAppear{
                if isNavigationStackUsed.wrappedValue != navigationStorage.isNavigationStackUsed {
                    isNavigationStackUsed.wrappedValue = navigationStorage.isNavigationStackUsed
                }
            }
    }
}
