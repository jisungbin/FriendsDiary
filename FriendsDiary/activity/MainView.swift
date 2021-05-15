//
//  MainView.swift
//  FriendsDiary
//
//  Created by Ji Sungbin on 2021/05/11.
//

import SwiftUI
import ExytePopupView

struct MainView: View {
    @State private var selectedImages = []
    @ObservedObject private var vm = MainViewModel.shared
    @State private var showBottomSheet = false
    @State private var showImagePicker = false
    @State private var showSuccessToast = true
    @State private var showErrorToast = false
    @State private var toastMessage = "환영합니다 :)"
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: { showBottomSheet.toggle() }) {
                    Image(systemName: "plus")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                }
                .frame(width: 70, height: 70)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color.yellow)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                )
            }.frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .bottomTrailing
            ).padding(30)
        }
        .edgesIgnoringSafeArea(.all)
        .popup(isPresented: $showSuccessToast, type: .floater(), position: .bottom, animation: Animation.spring(), autohideIn: 2) {
            createBottomToast(Color.blue)
        }
        .popup(isPresented: $showErrorToast, type: .floater(), position: .bottom, animation: Animation.spring(), autohideIn: 2) {
            createBottomToast(Color.pink)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                selectedImages.append(image)
            }
        }
        
        BottomSheetModal(display: $showBottomSheet) {
            createBottomSheetModal()
        }
    }
    
    private func createBottomSheetModal() -> some View {
        ZStack {
            VStack {
                ZStack {
                    HStack {
                        Text("추억 사진 업로드")
                            .font(.custom("MunhwajaeDolbom-Regular", size: 20))
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    HStack {
                        Text("2021년 5월 15일")
                            .padding()
                            .font(.custom("MunhwajaeDolbom-Regular", size: 15))
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.yellow)
                            )
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                }.padding().frame(maxWidth: .infinity, maxHeight: 50)
                if !selectedImages.isEmpty {
                    Image(uiImage: selectedImages.first as! UIImage)
                        .frame(width: .infinity, height: .infinity, alignment: .center)
                } else {
                    Color.blue
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Button(action: { showImagePicker.toggle() }) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                }
                .frame(width: 50, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color.yellow)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                )
                Button(action: { }) {
                    Image(systemName: "checkmark")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                }
                .frame(width: 50, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color.yellow)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                )
            }.padding().frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func createBottomToast(_ backgroundColor: Color) -> some View {
        Text(toastMessage)
            .padding(15)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(30)
    }
    
    private func diaryItemBind(item: Item) -> some View {
        VStack {
            HStack {
                let owner = vm.getUserFromUid(uid: item.owner)
                AsyncImage(
                    url: URL(string: owner.profileImageUrl)!,
                    placeholder: { Text("불러오는중...").font(.custom("MunhwajaeDolbom-Regular", size: 15)) },
                    image: { Image(uiImage: $0).resizable() }
                )
                VStack {
                    Text(owner.name).font(.custom("MunhwajaeDolbom-Regular", size: 20))
                    Text(item.date.description).font(.custom("MunhwajaeDolbom-Regular", size: 15))
                }
            }.frame(maxWidth: .infinity, maxHeight: 30)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
        }
    }
}
