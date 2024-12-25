//
//  ModularSecondView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 04.12.2023.
//

import SwiftUI
import SUINavigation

struct ModularSecondView: View {

    var number: Int

    // Don't use this approach, just for testing
    @Binding
    var numberFromParent: Int?

    @State
    private var isBoolShowed: Bool = false

    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?

    @Environment(\.isChange)
    private var isChange

    @Environment(\.presentationMode)
    private var presentationMode

    var body: some View {
        VStack {
            HStack{
                Text("This is Second")
                if isChange.wrappedValue {
                    Text("changed")
                } else {
                    Text("wait change")
                }
            }
            Text("with: \(number)")
            Button("to Bool") {
                isBoolShowed = true
            }
            Button("to Replace") {
                navigationStorage?.replaceDestination(with: ReplaceValue.replace("from Second"))
            }
            HStack {
                Button("to Root") {
                    navigationStorage?.popToRoot()
                }
                Button("to change") {
                    isChange.wrappedValue.toggle()
                }
            }
            HStack {
                Button("dismiss") {
                    presentationMode.wrappedValue.dismiss()
                }
                Button("popBack") {
                    navigationStorage?.pop()
                }
                Button("trigger to nil") {
                    // Yes, it is not working, because Modular use AnyView: technical imposible use Binding
                    //numberFromParent = nil
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Button("to URL: BoolView/FirstView/SecondView?firstString=??&secondNumber=88") {
                navigationStorage?.append(from: "BoolView/FirstView/SecondView?firstString=??&secondNumber=88")
            }
        }
        .padding()
        .navigationAction(isActive: $isBoolShowed, destinationValue: Destination.bool){ _ in
            isBoolShowed = true
        }
        .navigationStorageDestinationAction(for: ReplaceValue.self, id: "Replace", paramName: "replace")
    }
}

#Preview {
    ModularSecondView(number: 777, numberFromParent: .constant(0))
}
