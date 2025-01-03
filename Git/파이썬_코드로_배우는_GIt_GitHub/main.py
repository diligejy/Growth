# ch 4.4.1 main.py
import sys 
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QVBoxLayout, QMessageBox, QPlainTextEdit, QHBoxLayout
from PyQt5.QtGui import QIcon # icon 추가 위한 라이브러리

class Calculator(QWidget):
    
    def __init__(self):
        super().__init__() # 부모 클래스 QWidget 초기화
        self.initUI() # 나머지 초기화
        
    def initUI(self):
        self.te1 = QPlainTextEdit() # 텍스트 에디트 위젯 생성
        self.te1.setReadOnly(True) # 텍스트 에디트 위젯을 읽기만 가능하도록 수정
        
        self.btn1 = QPushButton("Message", self) # 버튼 추가 
        self.btn1.clicked.connect(self.activateMessage) # 버튼 클릭 시 핸들러 함수 연결
        
        self.btn2 = QPushButton("Clear", self)
        self.btn2.clicked.connect(self.clearMessage)
 
        hbox = QHBoxLayout() # 수평 박스 레이아웃 추가하고 버튼 1, 2 추가
        hbox.addStretch(1) # 공백
        hbox.addWidget(self.btn1) # 버튼 1 배치 
        hbox.addWidget(self.btn2) # 버튼 2 배치 
        
        vbox = QVBoxLayout() # 수직 레이아웃 위젯 생성
        vbox.addWidget(self.te1) # 수직 레이아웃에 텍스트 위젯 추가
        # vbox.addStretch(1) # 빈 공간
        # vbox.addWidget(self.btn1) # 버튼 위치
        vbox.addLayout(hbox) # btn1 위치에 hbox 배치
        vbox.addStretch(1) # 빈 공간
        
        
        self.setLayout(vbox) # 빈 공간 - 버튼 - 빈 공간 순으로 수직 배치된 레이아웃 설정
        
        
        self.setWindowTitle("Calculator")
        self.setWindowIcon(QIcon('icon.png')) # 윈도 아이콘 추가
        self.resize(256, 256)
        self.show()
        
        
    
    def activateMessage(self):
        # QMessageBox.information(self, "information", "Button Clicked!")
        # 핸들러 함수 수정 : 메시지가 텍스트 에디트에 출력되도록
        self.te1.appendPlainText("Button Clicked!")
        
    def clearMessage(self): # 버튼 2 핸들러 함수 정의
        self.te1.clear()

if __name__ == "__main__": # PyQt는 애플리케이션 당 1개의 QApplication이 필요
    app = QApplication(sys.argv) # QApplication 인스턴스 생성
    view = Calculator() # Calculator 윈도 인스턴스 생성
    sys.exit(app.exec_()) # 애플리케이션이 이벤트 처리를 하도록 루프 구동