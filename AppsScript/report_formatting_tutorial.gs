function formatReport() {
  let sheet = SpreadsheetApp.getActiveSpreadsheet();

  let headers = sheet.getRange('A1:F1');
  let table = sheet.getDataRange();

  headers.setFontWeight('bold');
  headers.setFontColor('white');
  headers.setBackground('#52489C');

  table.setFontFamily('Roboto');
  table.setHorizontalAlignment('center');
  table.setBorder(true, true, true, true, false, true, '#52489C', SpreadsheetApp.BorderStyle.SOLID);

  table.createFilter();
}


function  onOpen(){
  let ui = SpreadsheetApp.getUi();
  ui.createMenu('Custom Formatting').addItem("Format Report", 'formatReport').addToUi();
}