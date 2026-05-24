Sub GetCoupangHistory()

If Trim(Sheet1.Range("A2").Value) = "" Then
    MsgBox "A2 셀에 쿠팡 세션 쿠키를 먼저 입력해주세요." & vbNewLine & vbNewLine & _
           "[쿠키 가져오는 방법]" & vbNewLine & _
           "1. A5 셀 더블클릭 -> 브라우저에서 쿠팡 주문내역 페이지 열림" & vbNewLine & _
           "2. 쿠팡 로그인 후 F12 키 누르기" & vbNewLine & _
           "3. Network 탭 -> 페이지 새로고침 (F5)" & vbNewLine & _
           "4. 'order/list' 요청 클릭 -> Request Headers 확인" & vbNewLine & _
           "5. 'Cookie:' 값 전체 복사 (매우 긴 문자열)" & vbNewLine & _
           "6. A2 셀에 붙여넣기 후 버튼 다시 클릭", vbInformation, "세션 쿠키 없음"
    Exit Sub
End If

Dim o As Object: Dim URL As String
Dim sResult As String: Dim sPrevResult As String
Dim vHeader As Variant: Dim blnPass As Boolean: blnPass = False
Dim i As Long: Dim idx As Long: Dim y As Long: Dim WS As Worksheet

ReDim vHeader(0 To 1)
Set WS = ActiveSheet

WS.Range("G2:P1048576").ClearContents
Application.GoTo Reference:=WS.Cells(1, 7), Scroll:=True

vHeader(0) = Array("Cookie", Sheet1.Range("A2").Value)
vHeader(1) = Array("Referer", "https://mc.coupang.com/ssr/mobile/order/list")

For y = WS.Range("C4").Value To WS.Range("A4").Value Step -1
    i = 0
    Do
        If y = Year(Date) And i = 0 Then
            URL = "https://mc.coupang.com/ssr/mobile/order/list"
            Set o = GetHttp(URL, , , vHeader)
            Application.Wait Now + #12:00:01 AM#
            sResult = o.body.innerhtml
            ' 큰따옴표 이스케이프 핸들링 추가 1.2
            If InStr(1, "<script id=""__NEXT_DATA__"" type=""application/json"">", sResult) > 0 Then
                sResult = Splitter(sResult, "<script id=""__NEXT_DATA__"" type=""application/json"">", "</script>")
                If sResult <> "" Then
                    blnPass = True
                Else
                    Exit Do
                End If
                ExtractOrderData WS, sResult, idx
            ElseIf InStr(1, "<script id=__NEXT_DATA__ type=application/json>", sResult) > 0 Then
                sResult = Splitter(sResult, "<script id=__NEXT_DATA__ type=application/json>", "</script>")
                If sResult <> "" Then
                    blnPass = True
                Else
                    Exit Do
                End If
                ExtractOrderData WS, sResult, idx
            Else
                If sResult <> "" Then
                    blnPass = True
                Else
                    Exit Do
                End If
            End If
        Else
            If i > 0 Then
                URL = "https://mc.coupang.com/ssr/api/myorders/model?requestYear=" & y & "&pageIndex=" & i & "&size=3"
                Set o = GetHttp(URL, , , vHeader)
                sResult = o.body.innerhtml
                If sResult <> "" Then blnPass = True
                If Left(sResult, 200) = Left(sPrevResult, 200) Then Exit Do
                sPrevResult = sResult
                ExtractJsonDataToTable WS, sResult, idx
            End If
        End If
        i = i + 1
    Loop Until sResult = ""
    On Error GoTo 0
Next

If blnPass = False Then
    MsgBox "세션 쿠키가 만료되었거나 올바르지 않습니다." & vbNewLine & _
           "A2 셀의 쿠키를 새로 복사하여 입력 후 다시 실행하세요.", vbExclamation, "쿠키 오류"
Else
    MsgBox "쿠팡 구매내역 불러오기를 완료했습니다.", vbInformation
End If

End Sub

Sub OpenCoupangBrowser()
    CreateObject("WScript.Shell").Run "https://mc.coupang.com/ssr/desktop/order/list"
End Sub

Sub ExtractJsonDataToTable(WS As Worksheet, jsonText As String, ByRef idx As Long)

    Dim jsondata As Object
    Dim orders As Object: Dim order As Object
    Dim product As Object
    Dim vendorInfo As Object
    Dim businessNumber As String
    Dim vendorName As String
    Dim lastRow As Long: Dim rowIndex As Long
    Dim productIndex As Long: Dim sProductID As String: Dim sPrevProductID As String
    Dim i As Long, j As Long, k As Long
    Dim visibleRange As Range: Dim visibleRows As Long

    Set jsondata = mod_JsonConverter.ParseJson(jsonText)
    Set orderList = jsondata("orderList")
    Set visibleRange = Application.ActiveWindow.visibleRange
    visibleRows = visibleRange.Rows.Count

    Set orders = mod_JsonConverter.ParseJson(jsonText)("orderList")
    lastRow = WS.Cells(WS.Rows.Count, 7).End(xlUp).Row
    rowIndex = lastRow + 1

    For i = 1 To orders.Count
        On Error GoTo EH:
        Set order = orders(i)

        If order("deliveryGroupList")(1)("vendor") Is Nothing Then
            businessNumber = "정보 없음"
            vendorName = "정보 없음"
        Else
            Set vendorInfo = order("deliveryGroupList")(1)("vendor")
            businessNumber = vendorInfo("businessNumber")
            vendorName = vendorInfo("vendorName")
        End If

        For j = 1 To order("deliveryGroupList").Count
            Set deliveryGroup = order("deliveryGroupList")(j)

            For k = 1 To deliveryGroup("productList").Count
                Set product = deliveryGroup("productList")(k)
                sProductID = product("productId")
                If sProductID <> sPrevProductID Then
                    WS.Cells(rowIndex, 7).Value = Format(CDate(order("orderedAt") / 1000 / 86400 + 25569), "yyyy-mm-dd hh:mm:ss")
                    WS.Cells(rowIndex, 8).Value = Format(order("orderId"), "0")
                    WS.Cells(rowIndex, 9).Value = businessNumber
                    WS.Cells(rowIndex, 10).Value = vendorName
                    WS.Cells(rowIndex, 11).Value = Format(product("productId"), "0000000000")
                    WS.Cells(rowIndex, 12).Value = idx
                    WS.Cells(rowIndex, 13).Value = product("productName")
                    WS.Cells(rowIndex, 15).Value = product("unitPrice")
                    WS.Cells(rowIndex, 16).Value = deliveryGroup("groupStatus")("status")
                    rowIndex = rowIndex + 1: idx = idx + 1
                    sPrevProductID = product("productId")
                    If rowIndex > visibleRows Then Application.GoTo Reference:=WS.Cells(rowIndex - visibleRows, 7), Scroll:=True
                End If
            Next k
        Next j
        On Error GoTo 0
    Next i

Exit Sub

EH:
ExportText jsonText, "쿠팡_추출결과"
MsgBox "구매내역 추출 도중 오류가 발생했습니다." & vbNewLine & "오류가 발생한 구매내역 페이지는 바탕화면에 저장된 메모장을 확인주세요."
End

End Sub

Sub ExtractOrderData(WS As Worksheet, jsonText As String, ByRef idx As Long)

    Dim jsonParser As Object
    Set jsonParser = CreateObject("Scripting.Dictionary")
    Set jsonParser = mod_JsonConverter.ParseJson(jsonText)

    Dim orders As Object
    Dim OrderID As Variant
    Dim lastRow As Long: Dim rowIndex As Long

    lastRow = WS.Cells(WS.Rows.Count, 7).End(xlUp).Row
    rowIndex = lastRow + 1

    Set orders = jsonParser("props")("pageProps")("domains")("order")("entity")("entities")

    For Each OrderID In orders
        On Error GoTo EH:
        Dim order As Object
        Set order = orders(OrderID)

        Dim product As Object
        Dim productList As Object
        Dim shipment As Object
        Dim deliveredDate As Double
        Dim vendorInfo As Object
        Dim businessNumber As String
        Dim vendorName As String

        If order("deliveryGroupList")(1)("vendor") Is Nothing Then
            businessNumber = "정보 없음"
            vendorName = "정보 없음"
        Else
            Set vendorInfo = order("deliveryGroupList")(1)("vendor")
            businessNumber = vendorInfo("businessNumber")
            vendorName = vendorInfo("vendorName")
        End If

        For Each shipment In order("deliveryGroupList")
            For Each product In shipment("productList")
                WS.Cells(rowIndex, 7).Value = Format(CDate(order("orderedAt") / 1000 / 86400 + 25569), "yyyy-mm-dd hh:mm:ss")
                WS.Cells(rowIndex, 8).Value = Format(order("orderId"), "0")
                WS.Cells(rowIndex, 9).Value = businessNumber
                WS.Cells(rowIndex, 10).Value = vendorName
                WS.Cells(rowIndex, 11).Value = Format(product("productId"), "0000000000")
                WS.Cells(rowIndex, 12).Value = idx
                WS.Cells(rowIndex, 13).Value = product("productName")
                WS.Cells(rowIndex, 15).Value = product("unitPrice")
                WS.Cells(rowIndex, 16).Value = shipment("invoiceStatus")
                rowIndex = rowIndex + 1: idx = idx + 1
            Next product
        Next shipment
        On Error GoTo 0
    Next OrderID

Exit Sub

EH:
ExportText jsonText, "쿠팡_추출결과"
MsgBox "구매내역 추출 도중 오류가 발생했습니다." & vbNewLine & "오류가 발생한 구매내역 페이지는 바탕화면에 저장된 메모장을 확인주세요."
End

End Sub

Sub ExportText(InnerStrings As String, _
Optional FileName As String = "텍스트추출", _
Optional Path As String)

On Error GoTo EH:

If Path = "" Then Path = Environ("USERPROFILE") & "\Desktop\"
If Right(Path, 1) <> "\" Then Path = Path & "\"
filePath = Path & FileName & ".txt"

Dim fso As Object
Dim txtFile As Object
AfterMkDir:
Set fso = CreateObject("Scripting.FileSystemObject")
Set txtFile = fso.OpenTextFile(filePath, 2, True, -1)
txtFile.Write InnerStrings
txtFile.Close

Set txtFile = Nothing
Set fso = Nothing

Exit Sub
EH:
If Err.Number = 52 Then
    MsgBox "사용 중인 윈도우 설정 상, 파일 경로에 '한글'을 포함할 수 없습니다." & vbNewLine & "파일 경로를 다시 확인하세요."
ElseIf Err.Number = 76 Then
    MkDir Path
    Resume AfterMkDir:
Else
    MsgBox "오류가 발생했습니다." & vbNewLine & "오류번호 : " & Err.Number & vbNewLine & "설명 : " & Err.Description & vbNewLine & "발생 위치 : ExportText"
End If

End Sub
