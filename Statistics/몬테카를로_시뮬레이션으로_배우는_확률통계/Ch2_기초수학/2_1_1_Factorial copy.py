def factorial(x):
    """ 
    팩토리얼 함수 
    입력값: 정수 x
    출력값: x!
    """
    x_list = list(range(1, x + 1))
    res = 1 
    for val in x_list:
        res *= val
        
    return res 

