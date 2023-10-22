# ch 4.2.3 main.py
import sys 
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QVBoxLayout, QMessageBox
from PyQt5.QtGui import QIcon # icon 추가 위한 라이브러리

class Calculator(QWidget):
    
    def __init__(self):
        super().__init__() # 부모 클래스 QWidget 초기화
        self.initUI() # 나머지 초기화
        
    def initUI(self):
        self.btn1 = QPushButton("Message", self) # 버튼 추가 
        self.btn1.clicked.connect(self.activateMessage) # 버튼 클릭 시 핸들러 함수 연결
        
        vbox = QVBoxLayout() # 수직 레이아웃 위젯 생성
        vbox.addStretch(1) # 빈 공간
        vbox.addWidget(self.btn1) # 버튼 위치
        vbox.addStretch(1) # 빈 공간
        
        self.setLayout(vbox) # 빈 공간 - 버튼 - 빈 공간 순으로 수직 배치된 레이아웃 설정
        
        
        self.setWindowTitle("Calculator")
        self.setWindowIcon(QIcon('icon.png')) # 윈도 아이콘 추가
        self.resize(256, 256)
        self.show()
    
    def activateMessage(self):
        QMessageBox.information(self, "information", "Button Clicked!")
        

if __name__ == "__main__": # PyQt는 애플리케이션 당 1개의 QApplication이 필요
    app = QApplication(sys.argv) # QApplication 인스턴스 생성
    view = Calculator() # Calculator 윈도 인스턴스 생성
    sys.exit(app.exec_()) # 애플리케이션이 이벤트 처리를 하도록 루프 구동