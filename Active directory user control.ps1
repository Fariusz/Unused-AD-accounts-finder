#===MAIL CONFIG=======================================
$smtp = 'smtp.domain.i'
$MailText = "Wymagana kontrola kont użytkowników "
$Subject = "Kontrola kont użytkowników" 

#===GET CURRENT DATE IN SUBJECT=======================================
$CurrentYear = Get-Date -UFormat %Y
$CurrentMonth = (Get-Culture).DateTimeFormat.GetMonthName((Get-Date).Month)

$Subject = $Subject + " " + $CurrentMonth + " " + $CurrentYear

#===ADDON INSTALL=======================================
add-pssnapin quest.activeroles.admanagement 

#===GET OUTPUT=======================================
$PasswordNeverExpiresAccounts = (get-QADUser -SearchRoot '****' -Enabled -PasswordNeverExpires | select Name) | Out-String
$PasswordNeverExpiresAccounts = $PasswordNeverExpiresAccounts.Replace("Name", "Hasło nie wygasa na kontach:")

$NotLoggedOnFor30Days = (get-QADUser -SearchRoot '****' -Enabled -NotLoggedOnFor 30 | select Name) |Out-String
$NotLoggedOnFor30Days = $NotLoggedOnFor30Days.Replace("Name", "Nie logowano się od 30 dni na kontach:")

$body = $PasswordNeverExpiresAccounts + " " + $NotLoggedOnFor30Days

#===SEND MAIL=======================================
send-mailmessage -to your@mail.com -from ADserwer@mail.com -subject $Subject -body $body -smtpServer $smtp -ErrorAction Stop –Encoding ([System.Text.Encoding]::UTF8)
                       
