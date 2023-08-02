//
//  EditProfileRowView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/17.
//

import SwiftUI

struct EditProfileRowView: View {
	
	@Binding var text: String
	
	let Profile: String
	let placeholder: String
	
	var body: some View{
		
		VStack {
			HStack{
				Text(Profile)
					.font(.system(size: 18, weight: .bold, design: .default))
					.padding(.leading, 10)
					.baselineOffset(-5)
					.frame(width: 80, alignment: .leading)
				
				TextField(placeholder, text: $text)
					.font(.system(size: 16, weight: .regular, design: .default))
					.baselineOffset(-5)
				
			}
			.frame(width: UIScreen.main.bounds.width - 50 ,height: 44)
			Divider()
				.frame(width: UIScreen.main.bounds.width - 60)
		}
	}
}
