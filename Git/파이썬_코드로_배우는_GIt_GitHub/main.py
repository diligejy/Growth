# ch 4.2.1 main.py
import sys 
from PyQt5.QtWidgets import QApplication, QWidget # 애플리케이션 핸들러와 빈 GUI 위젯

class Calculator(QWidget):
    
    def __init__(self):
        super().__init__() # 부모 클래스 QWidget 초기화
        self.initUI() # 나머지 초기화
        
    def initUI(self):
        self.setWindowTitle("Calculator")
        self.resize(256, 256)
        self.show()
        

if __name__ == "__main__": # PyQt는 애플리케이션 당 1개의 QApplication이 필요
    app = QApplication(sys.argv) # QApplication 인스턴스 생성
    view = Calculator() # Calculator 윈도 인스턴스 생성
    sys.exit(app.exec_()) # 애플리케이션이 이벤트 처리를 하도록 루프 구동