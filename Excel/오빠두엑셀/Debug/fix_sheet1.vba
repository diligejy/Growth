Private Sub Worksheet_BeforeDoubleClick(ByVal Target As Range, Cancel As Boolean)
    If Not Intersect(Target, Me.Range("A5:C5")) Is Nothing Then
        Cancel = True
        CreateObject("WScript.Shell").Run "https://mc.coupang.com/ssr/desktop/order/list"
    End If
End Sub
