function myFunction() {

  let members = [];
  let mailCount = 0;
  let resultSheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("전송결과");

  for (let i = 4; i < 11; i++){
    let member = {};
    member['address'] = getValueFromSheet("후원자정보", i, 2); 
    member['name'] = getValueFromSheet("후원자정보", i, 3);
    member['role'] = getValueFromSheet("후원자정보", i, 4);

    members.push(member);

  }

  for (let i=0; i < members.length; i++){
    Logger.log(members[i]['address'] + " " + members[i]['name'] + " " + members[i]['role'])
  }

  let emailContents = []

  for (let i = 3; i < 6; i++){
    let content = {};
    content['title'] = getValueFromSheet("이메일내용", i, 3);
    content['body'] = getValueFromSheet("이메일내용", i, 4);
    content['foot'] = getValueFromSheet("이메일내용", i, 5);
    emailContents.push(content);
  }

  for (let i = 0; i < members.length; i++){
    setEmailContents(members[i], emailContents);
  }

  for (let i = 0; i < members.length; i++){
    MailApp.sendEmail(members[i]['address'], members[i]['content']['title'], members[i]['content']['body']);
    mailCount++;
  }
  // 시간대변경 라이브러리 : https://developers.google.com/apps-script/reference/utilities/utilities#formatdatedate,-timezone,-format
  // 시트에저장 라이브러리 : https://developers.google.com/apps-script/reference/spreadsheet/range#setvaluevalue
  // AppsScript 라이브러리 : https://developers.google.com/apps-script/reference?hl=ko
  let formattedDate = Utilities.formatDate(new Date(), 'Asia/Seoul', 'yyyy년 MM 월 dd일 HH:mm');
  resultSheet.getRange("C3").setValue(formattedDate);
  resultSheet.getRange("C4").setValue(mailCount);
}

function getValueFromSheet(sheet, row, column){
  let result = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(sheet).getRange(row, column).getValue();
  return result
}

function setEmailContents(member, emailContents){
  if (member['role'] == '정회원'){
    member['content'] = emailContents[0];
  } else if (member['role'] == '준회원'){
    member['content'] = emailContents[1];
  } else {
    member['content'] = emailContents[2];
  }
}
