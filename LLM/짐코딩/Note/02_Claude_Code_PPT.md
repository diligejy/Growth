1. SKILL-CREATOR란

- 스킬이 스킬을 만든다

- 공식문서 스펙과 모범 사례를 자동 반영 

- 기존 스킬도 개선 가능 


2. 예시 프롬프트

Research.md와 research-sample.html 두 파일을 읽고 
research-sample.html을 아래 4가지 수정해줘. 콘텐츠는 그대로 유지.

1. 뷰포트 풀스크린
- 위아래 여백 없이 브라우저 화면을 꽉 채우도록
- 스크롤 스냅 대신 JS fixed+absolute 전환 방식으로 변경

2. 다크/골드 프리미엄 컬러
- 그린 엑센트 -> 골드(#C6A55C) 전면 교체
- 텍스트는 차가운 화이트 대신 따뜻한 아이보리 계열로

3. 콘텐츠 폭 축소
- max-width: 1000px -> 680px로 줄이고 내부 컴포넌트도 비율에 맞게 축소

4. 한글 폰트 최적화
- Google Fonts에서 Noto Sans KR 추가 (wght 400:700)
- 한글 본문은 Noto Sans KR, 영문/코드는 기존 Inter + JetBrains Mono 유지
- font-family 우선순위 : 'Noto Sans KR', 'Inter' sans-serif

결과물은 단일 HTML 파일로 줘
