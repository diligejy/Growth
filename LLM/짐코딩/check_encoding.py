data = open(r'C:/Users/sjy04/.claude/skills/html-slide-deck-workspace/iteration-1/review.html', encoding='utf-8').read()
needles = ['회사', '당', '슬라이닜', '보여주고']  # 회사, 당, 슬라이드, 보여주고
results = []
for n in needles:
    idx = data.find(n)
    results.append(f'{n!r} -> {idx}')
with open('encoding_check_result.txt', 'w', encoding='utf-8') as f:
    f.write('\n'.join(results))
    f.write('\n\n--- sample around byte 18793 area in raw file ---\n')
raw = open(r'C:/Users/sjy04/.claude/skills/html-slide-deck-workspace/iteration-1/review.html', 'rb').read()
snippet = raw[18700:19000]
with open('encoding_check_result.txt', 'a', encoding='utf-8') as f:
    f.write(repr(snippet))
