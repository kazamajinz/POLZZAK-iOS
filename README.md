# POLZZAK-iOS

## 목차
- [프로젝트 소개](#프로젝트-소개)
    - [참여자](#참여자)
    - [프로젝트 기간](#프로젝트-기간)
- [📱 구현 화면](#-구현-화면)

- [🌐 Feature-1 Voice Over](#-Feature-1-Voice-Over)
    + [고민한 점](#1-1-고민한-점) 
    + [Trouble Shooting](#1-2-Trouble-Shooting)

- [🗺 Feature-2. 이미지 캐시](#-feature-2-이미지-캐시)
    + [고민한 점](#2-1-고민한-점)
    + [Trouble Shooting](#2-2-Trouble-Shooting)

- [📢 Feature-3. 음성 필터링](#-feature-2-음성-필터링)
    + [고민한 점](#2-1-고민한-점)


## 프로젝트 소개
폴짝! - 칭찬 도장판 서비스
손가락 거는 걸로는 부족한 우리에게 필요했던, 칭찬 도장판 서비스 🪄
약속한 선물을 얻기 위해 미션을 수행하면서 한 단계 더 폴짝! 성장할 아이들을 위해 만들어진 칭찬 도장판 서비스입니다.

### 기술 스택
- Swift, UIKit, Combine
- SnapKit, CombineCocoa, PanModal
- Quick, Nimble

### 참여자
- Pane @kazamajinz, 김진영 @z3rosmith

### 프로젝트 기간 
- 2023.04.13 - 진행중(23.10.05 출시예정일)

## 📱 구현 화면
|1. 도장판 화면|2. 쿠폰 화면|3. 알림 화면|4. 연동 화면|
|-|-|-|-|
|<img width="200" src="https://github.com/kazamajinz/DDaRa_Rx/assets/62927862/09525f12-4e8a-4d3c-a8b5-34a674e38829">|<img width="200" src="https://github.com/kazamajinz/DDaRa_Rx/assets/62927862/e92f192d-0d13-4a16-8009-6acfecd13363">|<img width="200" src="https://github.com/kazamajinz/DDaRa_Rx/assets/62927862/d2ce7ccb-b9ae-41d9-a12b-ba580e8f4029">|<img width="200" src="https://github.com/kazamajinz/DDaRa_Rx/assets/62927862/f8cd43fa-a779-490f-9bbd-566f018ee497">|
|||||||
|5. 쿠폰상세화면|6. 스켈레톤뷰|7. 바텀시트뷰|8. 검색화면|
|<img width="200" src="https://github.com/kazamajinz/DDaRa_Rx/assets/62927862/5511f15f-c681-48f0-a835-a3bf8d495911">|<img width="200" src="https://github.com/kazamajinz/DDaRa_Rx/assets/62927862/45a49288-2ca8-48da-8c15-4fcc44af83ed">|<img width="200" src="https://github.com/kazamajinz/DDaRa_Rx/assets/62927862/790d4467-db55-4ec4-8469-028d8a67fd87">|<img width="200" src="https://github.com/kazamajinz/DDaRa_Rx/assets/62927862/a145053a-3b57-4d95-a195-e5df7e3de00d">|



## 🌐 Architecture
#### 1️⃣ Clean Architecture + MVVM 적용
이 프로젝트에서는 명확한 계층 분리를 목적으로 MVVM 패턴과 Clean Architecture를 채택하였습니다. 특히, Domain Layer를 제외하고, Data Layer에는 Entity(Model)를 포함시켰습니다.

#### 2️⃣ Domain Layer 제외 이유
초기 설계 단계에서는 Domain Layer의 구현이 포함되어 있었습니다. 그러나, 서버에서 전달받은 데이터를 가공하는 과정이 주로 로그인 및 회원가입 로직에서만 필요하다고 판단하였습니다. 따라서 Domain Layer의 존재가 비효율적이라고 판단되어, 이를 제외하기로 결정하였습니다.

#### 3️⃣ Data Layer 추가 설명

**폴더구조**



# DatayLayer 설명

- **목적 및 목표**: 데이터를 가져오고 저장하는 실제 로직을 담당합니다. 이 계층은 네트워크 요청, 데이터베이스 요청 등과 같은 데이터 소스와 통신합니다.
- **구성 요소 및 설명**:
    - **Network**: 네트워크 요청과 관련된 모든 로직을 처리
        - **Enum**: Result, Error타입들을 정의
        - **Targets**: API의 특정 Endpoint나 경로를 정의
        - **Services**: 실제 네트워크 요청을 수행
        - **DTOs (Data Transfer Objects)**: API와의 통신 중 데이터 교환에 사용되는 객체
        - **Mappers**: DTOs를 DomainLayer의 Entity로 변환
    - **Repositories**: 데이터 소스에서 데이터를 가져오고 도메인 계층으로 전달

- 기본 단계
    - **Targets** → **Service** → **Repository**(Data) → **ViewModel**


## 🔍 협업
#### 1️⃣ 업무 분담
기본적으로, 프로젝트의 각 기능을 개별적으로 담당하기로 하였습니다. 하지만, 디자인 단계에서 기능 단위의 완성도가 떨어져, 일부 중복되는 업무가 발생하였습니다. 이에 따라, 일부 화면의 구현은 공동으로 수행하게 되었습니다.
- 예시로는 Main화면과 Coupon화면이 있습니다.


## 🗂️ 기본 컨벤션
#### 1️⃣ 폴짝 컨벤션
코딩 컨벤션과 커밋 컨벤션을 정의하였습니다.
링크: https://pinto-screen-798.notion.site/e71a6a600bcd4c4a837819dc0a718550?pvs=4
브랜치 전략은 PR시 코드리뷰 필수로 정하였습니다.

#### 2️⃣ 기술 스택
이 프로젝트에서는 주로 Combine과 SnapKit을 사용하였으며, 그 외의 라이브러리는 최대한 배제하였습니다.
Swift Concurrency(async/await)를 사용하기로 했습니다.
이러한 기술 스택 선정은 프로젝트의 단순성과 유지보수성을 위한 것입니다.

#### 3️⃣ 고찰
**combineCocoa**
Combine의 순수성과 강력함은 RxSwift와 비교했을 때 큰 장점이라고 생각했습니다. 그래서 CombineCocoa의 필요성에 대한 고민이 들었습니다.
처음에 combineCocoa를 프로젝트에 추가하려 했을 때는, 이 라이브러리가 제공하는 기능들이 매력적으로 보였습니다. 하지만 실제로 적용해보니, 이 라이브러리를 추가로 통합할 만큼의 충분한 가치를 보지 못했습니다.
예를 들어, 버튼에 액션을 추가하는 것은 편리했지만, 이 정도의 편리함만으로는 프로젝트에 새로운 라이브러리를 추가하는 것이 타당하지 않다고 생각했습니다.

**PanModal**
PanModal 역시 비슷한 이유로 직접 구현하는 방향을 선택했습니다.
제가 구현한 바텀시트뷰는 기능적으로는 더 가벼운 형태였고, 이 때문에 진영님도 사용하기 위해서는 추가적인 리팩토링이 필요했습니다. 시간적인 제약으로 인해, 진영님은 PanModal을 사용하기로 결정하셨습니다.
제가 바텀시트를 직접 구현한 주된 이유는, PanModal을 사용하면 기획에서 요구한 드래그로 열고 닫는 기능을 구현할 수 없어서 기획 자체를 변경해야 했기 때문입니다.
이는 유튜브의 댓글 기능에서 볼 수 있는 것처럼 우리 프로젝트에서도 구현 가능해야 한다고 생각한 부분이었습니다.

**Cuckoo**
Cuckoo를 사용한 이유는 Mock 객체의 생성과 관리에 있습니다.
Cuckoo는 Run Script를 이용하여 Mock 파일을 자동으로 생성해줍니다. 이렇게 생성된 Mock 객체는 원본 인터페이스가 변경되더라도 쉽게 최신화할 수 있습니다.
빌드 과정에서 자동으로 Mock 객체가 최신화되기 때문에, 팀원들은 수동으로 Mock 객체를 유지보수하는 데 시간을 소모하지 않아도 됩니다.
이런 점이 Cuckoo를 사용하여 개발하는 데 매우 편리하다고 판단했습니다.
RunScript를 For문으로 사용했더니 생성은 되도 내용물이 1개로 통일되는 현상이 생겼습니다.
스택플로우에 올렸으나 아직 해결방안을 얻지 못했습니다.

**Nimble**
저희는 테스트 코드의 가독성을 매우 중요하게 생각합니다.
코드의 가독성은 팀원 모두에게 코드를 더 이해하기 쉽게 만들어주며, 이는 결국 유지보수성을 향상시키고 버그를 줄여줍니다.
이러한 이유로, 저희는 Nimble을 선택했습니다.
또한, Nimble은 Swift의 async/await와 잘 결합되어 비동기 코드의 테스트가 더욱 간결하고 명료해집니다.

**Quick를 안쓴이유**
이러한 결정의 배경에는 라이브러리의 지원 상태도 큰 영향을 끼쳤는데, Nimble은 이미 async/await를 지원하고 있었지만 Quick은 아직 그렇지 않았습니다.
Quick에는 비동기 코드를 처리하기 위해 **`toEventually`**나 **`waitUntil`**과 같은 매처가 제공되고 있지만, 이를 사용하더라도 async/await를 사용했을 때만큼의 간결함과 명료함은 얻기 어려웠습니다.
그러한 이유로 제외했습니다.


## 📚 모듈화 및 추가기능 구현 설명

#### 1️⃣ 모듈화
1. Toast
사용자 경험 향상을 위해 3초 후에 자동으로 사라지거나 사용자가 직접 사라지게 할 수 있습니다.
2. SearchBar
패딩, UI 스타일 등을 기획대로 구현하기 위해 커스텀으로 사용했습니다.
3. BottomSheetView
팬모달 기능을 제공하여, 사용자가 콘텐츠를 더 효과적으로 볼 수 있게 하였습니다.
4. SkeletonView
기존 라이브러리의 제약으로 인해 직접 구현하였으며, 각 뷰에 애니메이션을 추가한 형태입니다.
5. AlertView
다양한 알림 타입(Loading, Button, Title)을 구현하여 사용자에게 필요한 정보를 제공합니다.
6. Loading Indicator & ViewModel
로딩 바를 여러 곳에서 재사용할 수 있도록 구현하여 사용자가 시스템 상태를 인지할 수 있게 했습니다.
7. Tab & Filter View & ViewModel Protocol
TabView와 FilterView를 결합하여, 다양한 화면에서 재사용할 수 있도록 구현하였습니다.
8. PullToRefreshProtocol
사용자가 스크롤을 아래로 당겨서 리로드할 수 있는 기능을 제공하며, 커스텀 이미지를 사용하기 위해 직접 구현하였습니다. 완전한 모듈화를 위한 리팩토링이 필요합니다.
9. ErrorHandlingProtocol
에러 처리 기획이 확정될 때 일괄적으로 적용할 수 있도록 프로토콜을 구현하였습니다.

#### 2️⃣ 추가 기능
1. 닉네임 검색 취소 기능
검색이 오래 걸릴 경우 사용자가 직접 검색을 취소할 수 있도록 구현하였습니다. 이를 위해 Task를 취소 및 nil처리하여 Task자체를 제거하였습니다.
2. 쿠폰 캡처 기능
쿠폰 상세 화면에서 특정 부분을 캡처하고 라벨을 추가하여 쿠폰에 특정 문구를 포함시켰습니다.
이렇게 구체적으로 설명하면 각 모듈과 기능에 대한 이해도가 높아지며, 각 기능의 목적과 사용성에 대해 명확히 알 수 있을 것입니다.



