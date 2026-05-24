try {
    $xl = New-Object -ComObject Excel.Application
    $xl.Visible = $false
    $xl.DisplayAlerts = $false
    $fixedPath = 'C:\Users\sjy04\Videos\Growth\Excel\오빠두엑셀\Excel_File\05_쿠팡 네이버 구매내역 자동화 템플릿 v2.2_fixed.xlsm'
    $wb = $xl.Workbooks.Open($fixedPath)
    $vba = $wb.VBProject
    Write-Output "Protected=$($vba.Protection) Count=$($vba.VBComponents.Count)"

    # Modify a_CoupangModule
    $coupMod = $vba.VBComponents.Item('a_CoupangModule')
    $cm = $coupMod.CodeModule
    if ($cm.CountOfLines -gt 0) { $cm.DeleteLines(1, $cm.CountOfLines) }
    $newCode = [System.IO.File]::ReadAllText('C:\Users\sjy04\Videos\Growth\Excel\오빠두엑셀\Debug\fix_coupang.vba', [System.Text.Encoding]::UTF8)
    $cm.AddFromString($newCode)
    Write-Output "a_CoupangModule: $($cm.CountOfLines) lines"

    # Add BeforeDoubleClick to Sheet1
    $sh1 = $vba.VBComponents.Item('Sheet1')
    $sh1cm = $sh1.CodeModule
    $sheet1Code = [System.IO.File]::ReadAllText('C:\Users\sjy04\Videos\Growth\Excel\오빠두엑셀\Debug\fix_sheet1.vba', [System.Text.Encoding]::UTF8)
    $sh1cm.AddFromString($sheet1Code)
    Write-Output "Sheet1: $($sh1cm.CountOfLines) lines"

    # Remove A5 hyperlink
    $ws1 = $wb.Sheets.Item(1)
    $hlList = @()
    foreach ($hl in $ws1.Hyperlinks) { $hlList += $hl }
    foreach ($hl in $hlList) {
        if ($hl.Range.Row -eq 5) {
            $hl.Delete()
            Write-Output "A5 hyperlink removed"
            break
        }
    }

    $wb.Save()
    Write-Output "Saved OK"
    $wb.Close($false)
    $xl.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl) | Out-Null
} catch {
    Write-Output "ERROR: $_"
    try { $xl.Quit() } catch {}
}
