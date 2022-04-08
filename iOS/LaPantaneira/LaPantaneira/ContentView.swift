//
//  ContentView.swift
//  LaPantaneira
//
//  Created by Allan Melo on 11/03/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    fileprivate func menuButtons() -> some View {
        return HStack {
            if viewModel.testMode {
                DSButton(title: "Led On") {
                    viewModel.sendUDP("1")
                }
                
                DSButton(title: "Led Off") {
                    viewModel.sendUDP("2")
                }
            }
            
            DSButton(title: "Stop ESCs") {
                self.viewModel.throttle = 0
                self.viewModel.resetValues()
            }
            
            DSButton(title: viewModel.enableAccelerometer ? "Acelerometer On" : "Accelerometer Off" ) {
                self.viewModel.enableAccelerometer.toggle()
            }
            
            DSButton(title: viewModel.testMode ? "TestMode On" : "TestMode Off" ) {
                self.viewModel.testMode.toggle()
            }
        }
    }
    
    fileprivate func inputTextButton() -> some View {
        return HStack {
            TextField(
                "Input Text",
                text: $viewModel.inputText
            )
                .foregroundColor(.white)
            
            DSButton(title: "Send Input") {
                viewModel.sendUDP(viewModel.inputText)
            }
        }
    }
    
    fileprivate func outputValues() -> some View {
        return HStack {
            Text("leftEscValue: \(viewModel.leftEscValue)")
            if viewModel.enableAccelerometer {
                Text("X: \(viewModel.x)")
            }
            Text("rightEscValue: \(viewModel.rightEscValue)")
        }
    }
    
    fileprivate func throttle() -> VStack<TupleView<(Text, Slider<EmptyView, EmptyView>)>> {
        return VStack {
            Text("Throttle \(Int(viewModel.throttle))")
            Slider(value: Binding(get: {
                self.viewModel.throttle
            }, set: { (newVal) in
                self.viewModel.throttle = newVal
                self.viewModel.sendValues()
            }), in: -50...50) { _ in
                self.viewModel.sendValues()
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if !viewModel.enableAccelerometer {
                
                GeometryReader { geo in
                    VerticalSlider(
                        value: Binding(get: {
                            self.viewModel.leftEsc
                        }, set: { (newVal) in
                            self.viewModel.leftEsc = newVal
                            self.viewModel.sendValues()
                        }),
                        sliderHeight: geo.size.height,
                        anchor: .topLeading
                    ) { _ in
                        self.viewModel.resetValues()
                    }
                    .padding(.top, (geo.size.height) + 10)
                    .padding(.leading, 10)
                }
            }
            
                
                VStack(spacing: 20) {
                    if viewModel.testMode {
                        inputTextButton()
                    }
                    
                    menuButtons()
                    
                    throttle()
                    
                    outputValues()
                }
                .frame(minWidth: 600)
            
            if !viewModel.enableAccelerometer {
                GeometryReader { geo in
                    VerticalSlider(
                        value: Binding(get: {
                            self.viewModel.rightEsc
                        }, set: { (newVal) in
                            self.viewModel.rightEsc = newVal
                            self.viewModel.sendValues()
                        }),
                        sliderHeight: geo.size.height,
                        anchor: .leading
                    ) { _ in
                        self.viewModel.resetValues()
                    }
                    .padding(.top, geo.size.height)
                    .padding(.leading, geo.size.width / 2 + 20)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 812, height: 375)) // 1
            .environment(\.horizontalSizeClass, .compact) // 2
            .environment(\.verticalSizeClass, .compact)
    }
}

import SwiftUI

struct VerticalSlider: View {
    @Binding var value : Float
    var sliderHeight: CGFloat
    var anchor: UnitPoint
    var onChanged: (Bool) -> Void
    
    var body: some View {
        Slider(
            value: self.$value,
            in: 0...100,
            step: 1,
            onEditingChanged: onChanged
        ).rotationEffect(.degrees(-90.0), anchor: anchor)
            .frame(width: sliderHeight)
    }
}
