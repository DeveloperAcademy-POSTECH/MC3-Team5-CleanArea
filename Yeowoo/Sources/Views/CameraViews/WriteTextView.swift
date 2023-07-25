//
//  WriteTextView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/16.
//

import SwiftUI

struct WriteTextView: View {
    @Binding var showModal: Bool
    @Binding var contentsText: String
    @Binding var image: UIImage
    @Binding var didPhoto: Bool
    let backText: String = "사진에 대한 설명을 작성해주세요. (선택)"
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
                
                ZStack {
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
                    
                    if contentsText.isEmpty {
                        VStack {
                            HStack {
                                Text(backText)
                                    .font(.custom18semibold())
                                    .foregroundColor(Color("G3"))
                                    .padding(EdgeInsets(top: UIScreen.getHeight(23), leading: UIScreen.getWidth(40), bottom: UIScreen.getHeight(12), trailing: UIScreen.getWidth(32)))
                                
                                Spacer()
                            }
                            
                            Spacer()
                        }
                    }
                }
                
//                HStack {
//                    Spacer()
//
//                    VStack {
//                        Button(action: {
//                            contentsText = ""
//                        }) {
//                            Image(systemName: "xmark.circle.fill")
//                                .foregroundColor(Color("G3"))
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: UIScreen.getWidth(18))
//                                .padding(.trailing, UIScreen.getWidth(32))
//                        }
//                        .padding(.top, UIScreen.getHeight(22))
//
//                        Spacer()
//                    }
//                }
            }
            
            Spacer()
                .frame(height: UIScreen.getWidth(12))
            
            Button(action: {
                didPhoto = false
                showModal = false
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//                isWirte = false
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("ButtonColor"))
                        .frame(height: UIScreen.getHeight(54))
                        .padding([.leading, .trailing], UIScreen.getWidth(20))
                    
                    Text("업로드하기")
                        .font(.custom18semibold())
                        .foregroundColor(.white)
                }
            }
        }
    }
}
//
//struct WriteTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        WriteTextView(isWirte: .constant(true), contentsText: .constant(""))
//    }
//}
