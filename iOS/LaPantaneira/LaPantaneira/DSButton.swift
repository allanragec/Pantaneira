//
//  DSButton.swift
//  DesignSystem
//
//  Created by Allan Melo on 19/12/21.
//

import SwiftUI

public struct DSButton: View {
    let title: String
    let action: () -> Void
    let titleColor: Color
    let backgroundColor: Color
    
    public init(
        title: String,
        titleColor: Color = .white,
        backgroundColor: Color = .blue,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
    }
    public var body: some View {
        Button(action: action)
        {
            HStack {
                Spacer()
                Text(title)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .font(.custom("HelveticaNeue-Regular", size: 22))
        .multilineTextAlignment(.center)
        .padding(10)
        .foregroundColor(titleColor)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct DSButton_Previews: PreviewProvider {
    static var previews: some View {
        DSButton(title: "Button", action: {})
    }
}
