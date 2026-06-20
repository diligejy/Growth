# 순수 HTML/CSS/JS 슬라이드 프레젠테이션 리서치

외부 라이브러리(Reveal.js 등) 없이 바닐라로 풀스크린 슬라이드 프레젠테이션을 구현하는 방법에 대한 리서치 종합. Reveal.js의 구현 방식은 참고만 했으며 최종 제안은 의존성 없는 순수 코드.

## 1. 추천 구조

`deck`(전체 화면) → `viewport`(16:9 비율 영역) → `slide`(개별 섹션) 3단 DOM 구조에 `aspect-ratio: 16/9` + 레터박싱, 전환은 Web Animations API + `isAnimating` 락, 콘텐츠 빌드는 `data-step` 기반 fragment 패턴을 결합.

```html
<main class="deck">
  <div class="viewport">
    <section class="slide present" data-step-max="0">...</section>
    <section class="slide future">...</section>
  </div>
</main>
```

```css
.deck { position: fixed; inset: 0; display: flex; align-items: center; justify-content: center; background: #000; }
.viewport { position: relative; width: 100vw; aspect-ratio: 16/9; max-height: 100vh; background: #fff; overflow: hidden; }
.slide { position: absolute; inset: 0; opacity: 0; visibility: hidden; transform: translate3d(0,0,0); }
.slide.present { opacity: 1; visibility: visible; z-index: 2; }
.slide.past { transform: translate3d(-100%,0,0); z-index: 1; }
.slide.future { transform: translate3d(100%,0,0); z-index: 1; }
```

상태는 `current`(슬라이드 인덱스) + `step`(슬라이드 내 fragment 인덱스) 2개 변수로 충분. 키보드/스와이프/URL hash가 모두 같은 `goTo()` 단일 진입점을 거치는 구조가 버그를 줄인다.

## 2. 핵심 패턴 (영역별 Best Practice)

**레이아웃 & DOM 구조**
- `aspect-ratio: 16/9` + `max-width/max-height: 100vw/100vh`로 자동 레터박싱 (구형 브라우저는 `padding-top: 56.25%` 폴백).
- 3단 구조(`deck`/`viewport`/`slide`)로 풀스크린 컨테이너와 비율 고정 영역 분리.
- 비활성 슬라이드는 `aria-hidden`/`inert` 토글 — 스크린리더 접근성 필수.

**키보드 & 마우스 네비게이션**
- 키보드 핸들러 최상단에서 `activeElement`가 input/textarea/contentEditable이면 즉시 return.
- `location.hash` 직접 대입 대신 `history.pushState`/`replaceState` 사용 — hash 대입은 스크롤 점프를 유발.
- 스와이프는 `touchend`에서 가로 델타가 세로보다 클 때만 처리해 세로 스크롤 보존.

**전환 애니메이션**
- CSS Transition보다 Web Animations API 권장 — `.finished` Promise로 정확한 완료 감지, `transitionend` 미발생 엣지케이스 회피.
- `transform`/`opacity`만 애니메이션(컴포지터 전용), `top`/`width` 등은 매 프레임 reflow 유발.
- `isAnimating` boolean 락을 전환 함수 진입점에 둬서 모든 입력 경로(키보드/스와이프/클릭)를 한 곳에서 차단.

**콘텐츠 빌드 애니메이션**
- `data-step="N"` 속성 + `.visible` 클래스 토글로 순차 등장, 같은 N은 동시 등장 가능.
- `display:none`은 transition이 안 걸리므로 fragment는 반드시 `opacity`/`transform` 기반.
- 화자 노트는 `<aside class="notes">` + `display:none` 기본 숨김, 발표자 창은 `BroadcastChannel`로 동기화.

## 3. 주의 사항

- `100vh`는 모바일 Safari 주소창 변화로 흔들림 → `100dvh` 고려.
- `will-change`를 모든 슬라이드에 상시 적용하면 GPU 레이어 폭증 — 전환 직전 추가, 종료 후 `auto`로 제거.
- `keydown`에서 `e.repeat` 체크 누락 시 키를 누르고 있을 때 슬라이드가 과도하게 넘어감.
- `prefers-reduced-motion: reduce` 무시 금지 — 매칭 시 duration을 50ms 이하로 단축.
- speaker notes를 `display:none`만으로 숨기면 인쇄/PDF 내보내기에서도 사라짐 — `@media print` 별도 처리 필요.
- past/future 슬라이드에 같은 z-index를 주면 전환 중 깜빡임(flicker) 발생.
- `aspect-ratio`는 IE·Safari≤14.1 미지원 — `@supports not (aspect-ratio: ...)` 폴백 필요.

## 4. 샘플 코드

`vanilla-slides-sample.html` 참조 — 3슬라이드, WAAPI 기반 fade+slide 전환, fragment 빌드, 코드 줄 강조, 화자 노트, 키보드/스와이프/URL hash 네비게이션 포함.
