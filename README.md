# MC3 - Yeowoo
![KakaoTalk_Photo_2023-08-08-14-23-10](https://github.com/DeveloperAcademy-POSTECH/MC3-Team5-CleanArea/assets/50910456/e1f7b29a-76c5-47ea-a448-215427f0435f)


## About Yeowoo

<b>여우는 여행 중 일어나는 다채로운 순간들의 한 부분을 담당해 빠짐 없이 사진으로 기록하여 서로 다른 시각에서 본 우리 여행의 모든 순간을 기억하는 공유앨범 서비스입니다.

## About CleanArea
| [Azhy](https://github.com/ungchun) | Nova | [Pin](https://github.com/pingse) | [Jigu](https://github.com/Jisull) | [Caesar](https://github.com/4shimi) | Jamie |
|:-----------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------------------------------------------:|
| <img src="https://github.com/DeveloperAcademy-POSTECH/MC2-Team5-Snooze/assets/81157265/5dfa0cf8-fc19-40d5-ae3e-336af000df5c" width="100"/> | <img src="https://github.com/DeveloperAcademy-POSTECH/MC3-Team5-CleanArea/assets/50910456/1111608d-4ae9-49c5-bb4a-238c7bb24da5" width ="100"/> |<img src="https://github.com/DeveloperAcademy-POSTECH/MC3-Team5-CleanArea/assets/50910456/6954ef8f-2c52-4618-a9f2-ac803662be5d" width="100" height="100" /> | <img src="https://github.com/DeveloperAcademy-POSTECH/MC3-Team5-CleanArea/assets/50910456/0f266694-a742-4b04-8d4c-1a6ef627c286" width ="100"/> | <img src="https://github.com/DeveloperAcademy-POSTECH/MC3-Team5-CleanArea/assets/104481869/d7c8902a-cec5-42ef-a722-de05520cd735" width="100"> | <img src="https://github.com/DeveloperAcademy-POSTECH/MC3-Team5-CleanArea/assets/50910456/b0ae6004-7351-402c-9b21-64e8630131c4" width ="100"/> |
| Tech | PM | Tech | Tech | Tech | Design                                                                                                                     



<br>

## Development Environment
<img width="70" src="https://img.shields.io/badge/IOS-16%2B-silver">  <img width="85" src="https://img.shields.io/badge/Xcode-14.3-blue">

<br>

## Skills
* SwiftUI
* Firebase

## Convention

<details>
<summary>Commit Convention</summary><br>
  
 * `Udacity Git Commit Message Style Guide`를 참고
 * `Gitmoji` 사용  <br>
  
| Gitmoji | Header | 설명 |
| --- | --- | --- |
| :sparkles: | feat: | 새로운 기능에 대한 커밋 |
| :bug: | fix: | 버그 수정에 대한 커밋 |
| :memo: | docs: | 문서 수정에 대한 커밋 |
| :lipstick: | style: | UI 스타일에 관한 커밋 |
| :recycle: | refactor: | 코드 리팩토링에 대한 커밋 |
| :white_check_mark: | test: | 테스트 코드 수정에 대한 커밋 |
| :tada: | init: | 프로젝트 시작에 대한 커밋 |
| :heavy_plus_sign: | plus: | 의존성 추가에 대한 커밋 |
| :heavy_minus_sign: | minus: | 의존성 제거에 대한 커밋 |
| :hammer: | chore: | 그 외 자잘한 수정에 대한 커밋 (기타 변경 사항) |
</details>
<br>

## Folder Architecture

<pre>
<code>
Sources
 ┣ Component
 ┃ ┣ BackToolBarModifier.swift
 ┃ ┣ CardViewModifier.swift
 ┃ ┣ EditProfileRowView.swift
 ┃ ┣ FindFriendContents.swift
 ┃ ┣ FoxCardView.swift
 ┃ ┣ GrayTitleMakingView.swift
 ┃ ┗ NotiCardContentsView.swift
 ┣ Global
 ┃ ┣ CacheAsyncImage.swift
 ┃ ┣ Color+.swift
 ┃ ┣ Font+.swift
 ┃ ┣ String+.swift
 ┃ ┣ UINavigationController+.swift
 ┃ ┣ UIScreen+.swift
 ┃ ┗ View+.swift
 ┣ Models
 ┃ ┣ MainModel
 ┃ ┃ ┗ MainModel.swift
 ┃ ┣ Album.swift
 ┃ ┣ Fox.swift
 ┃ ┣ Notification.swift
 ┃ ┗ User.swift
 ┣ Services
 ┃ ┣ Firebase
 ┃ ┃ ┣ FirebaseError.swift
 ┃ ┃ ┗ FirebaseService.swift
 ┃ ┣ KeyChain
 ┃ ┃ ┣ KeyChainAccount.swift
 ┃ ┃ ┣ KeyChainError.swift
 ┃ ┃ ┗ KeyChainManager.swift
 ┃ ┗ UserDefaults
 ┃ ┃ ┣ UserDefaultsSetting.swift
 ┃ ┃ ┗ UserDefaultsWrapper.swift
 ┣ ViewModels
 ┃ ┣ AlbumViewModel.swift
 ┃ ┣ AuthViewModel.swift
 ┃ ┣ CameraViewModel.swift
 ┃ ┣ FindFriendViewModel.swift
 ┃ ┣ InvitationViewModel.swift
 ┃ ┣ MainViewModel.swift
 ┃ ┣ NotificationViewModel.swift
 ┃ ┗ SettingViewModel.swift
 ┣ Views
 ┃ ┣ Album
 ┃ ┃ ┣ Layouts
 ┃ ┃ ┃ ┣ FirstFeedLayout.swift
 ┃ ┃ ┃ ┣ GalleryLayout.swift
 ┃ ┃ ┃ ┗ SecondFeedLayout.swift
 ┃ ┃ ┣ AlbumDetailView.swift
 ┃ ┃ ┣ AlbumFeedView.swift
 ┃ ┃ ┗ InviteFriendView.swift
 ┃ ┣ Auth
 ┃ ┃ ┣ LoginCoverView.swift
 ┃ ┃ ┣ LoginView.swift
 ┃ ┃ ┗ SignUpView.swift
 ┃ ┣ CameraViews
 ┃ ┃ ┣ Components
 ┃ ┃ ┃ ┣ FeatureButton.swift
 ┃ ┃ ┃ ┗ RoleButton.swift
 ┃ ┃ ┣ Buttons.swift
 ┃ ┃ ┣ CameraButtonView.swift
 ┃ ┃ ┣ EditView.swift
 ┃ ┃ ┣ RoleView.swift
 ┃ ┃ ┗ WriteTextView.swift
 ┃ ┣ Main
 ┃ ┃ ┣ Components
 ┃ ┃ ┃ ┣ NewAlbumButton.swift
 ┃ ┃ ┃ ┣ Person.swift
 ┃ ┃ ┃ ┣ PlusPerson.swift
 ┃ ┃ ┃ ┣ TapePicture.swift
 ┃ ┃ ┃ ┗ TravelLabel.swift
 ┃ ┃ ┣ Layouts
 ┃ ┃ ┃ ┣ AlbumLayout.swift
 ┃ ┃ ┃ ┣ BeforeTravelLayout.swift
 ┃ ┃ ┃ ┣ DoneTravelLayout.swift
 ┃ ┃ ┃ ┣ NoAlbumLayout.swift
 ┃ ┃ ┃ ┗ RecommendLayout.swift
 ┃ ┃ ┗ MainView.swift
 ┃ ┣ NewAlbum
 ┃ ┃ ┣ AlbumRoleSelectView.swift
 ┃ ┃ ┣ FindFriendView.swift
 ┃ ┃ ┗ NewAlbumView.swift
 ┃ ┣ Notification
 ┃ ┃ ┣ EmptyNotificationView.swift
 ┃ ┃ ┣ NoticardView.swift
 ┃ ┃ ┗ NotificationView.swift
 ┃ ┣ Onboarding
 ┃ ┃ ┗ OnboardingView.swift
 ┃ ┣ Role
 ┃ ┃ ┣ InvitationChildView
 ┃ ┃ ┃ ┣ MultiInvitationView.swift
 ┃ ┃ ┃ ┗ TwoInvitationView.swift
 ┃ ┃ ┣ InvitationView.swift
 ┃ ┃ ┣ RoleChangeView.swift
 ┃ ┃ ┗ RoleSelectView.swift
 ┃ ┗ Setting
 ┃ ┃ ┣ ProfileSettingView.swift
 ┃ ┃ ┗ SettingView.swift
 ┗ ContentView.swift
</code>
</pre>
