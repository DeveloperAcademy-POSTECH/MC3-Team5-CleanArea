//
//  WriteTextView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/16.
//

import SwiftUI

struct WriteTextView: View {
    @Binding var isWirte: Bool
    @Binding var contentsText: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: UIScreen.getHeight(24))
            
            Text("글쓰기")
                .font(.custom18bold())
            
            Spacer()
                .frame(height: UIScreen.getHeight(24))
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("G5"))
                    .padding([.leading, .trailing], UIScreen.getWidth(20))
                
                TextEditor(text: $contentsText)
                    .font(.custom18semibold())
                    .foregroundColor(Color("G3"))
                    .scrollContentBackground(.hidden)
                    .padding(EdgeInsets(top: UIScreen.getHeight(12),
                                        leading: UIScreen.getWidth(32),
                                        bottom: UIScreen.getHeight(12),
                                        trailing: UIScreen.getWidth(50))
                    )
                    .lineSpacing(5)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                
                HStack {
                    Spacer()
                    
                    VStack {
                        Button(action: {
                            contentsText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color("G3"))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.getWidth(18))
                                .padding(.trailing, UIScreen.getWidth(32))
                        }
                        .padding(.top, UIScreen.getHeight(22))
                        
                        Spacer()
                    }
                }
            }
            
            Spacer()
                .frame(height: UIScreen.getWidth(12))
            
            Button(action: {
                isWirte = false
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("ButtonColor"))
                        .frame(height: UIScreen.getHeight(54))
                        .padding([.leading, .trailing], UIScreen.getWidth(20))
                    
                    Text("완료")
                        .font(.custom18semibold())
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct WriteTextView_Previews: PreviewProvider {
    static var previews: some View {
        WriteTextView(isWirte: .constant(true), contentsText: .constant("fdfdfd"))
    }
}
