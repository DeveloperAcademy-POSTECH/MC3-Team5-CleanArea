//
//  GrayTitleMakingView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/18.
//

import SwiftUI

struct GrayTitleMakingView: View {
	
	@Binding var text: String
	
	let placeholder: String
	
	var body: some View{
		VStack {
			VStack{
				HStack {
					Spacer()
						.frame(width: 10)
					
					TextField(placeholder, text: $text)
						.font(.system(size: 16, weight: .regular, design: .default))
						.frame(width: UIScreen.width - 60 ,height: 50)
				}
				.background(Color.whiteGray2)
				.cornerRadius(10)
			}
		}
	}
}
