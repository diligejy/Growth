def seq(start, stop, step):
    """ 
    수열 만들기
    입력값: start(시작 값), stop(끝 값), step(한 스텝당 증가 수)
    출력값: res(리스트)
    """
    res = []
    current = start
    while current < stop:
        res.append(current)
        current += step 
    return res 

print(seq(2, 10, 1))