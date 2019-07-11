[cmdletBinding()]
param
(
[parameter(Mandatory =$true)]
[ValidateNotNullOrEmpty()]
$From,
[parameter(Mandatory =$true)]
[ValidateNotNullOrEmpty()]
[string[]]$To,
[parameter(Mandatory =$true)]
[ValidateNotNullOrEmpty()]
$attachmentPath,
[parameter(Mandatory =$true)]
[ValidateNotNullOrEmpty()]
$SaltAutomationBranch,
[parameter(Mandatory =$true)]
[ValidateNotNullOrEmpty()]
$ExecutionEnvironment,
[parameter(Mandatory =$true)]
[ValidateNotNullOrEmpty()]
$CategoriesExecuted,
[parameter(Mandatory =$true)]
[ValidateNotNullOrEmpty()]
$envID
)

#$envID='{"RGT": 96337925,"DIT2":100106245}'

$encode_credentials = "XXXXXXXXXXXX"
$basicAuthvalue = "Basic $encode_credentials";
$header = @{ Authorization = $basicAuthvalue }

$ID=($envID | ConvertFrom-Json).$ExecutionEnvironment
$url = "http://<bamboo-URL>/rest/api/latest/deploy/environment/$ID/results"
$request = Invoke-WebRequest -Uri $url -Headers $header
$json = $request | ConvertFrom-Json
#$deploymentVersionName = $json.results[0].deploymentVersionName
$deploymentVersionName = ($json.results | Where-Object {$_.deploymentstate -eq "SUCCESS"} | select -First 1).deploymentversionname


$Subject = "Regression Function Automation $ExecutionEnvironment Integration"
#$Body = "PFA consolidated report of regression function automation of SALT!!!! `n`n Deployed version of SALT ::`t $deploymentVersionName`n`n Branch Name ::`t  $SaltAutomationBranch `n`n Execution Environment ::`t  $ExecutionEnvironment `n`n CategoriesExecuted ::`t  $CategoriesExecuted "
$Body = "<b><font color=Blue> PFA consolidated report of regression function automation of SALT!!!! </b></font><br><br>"
$Body += "<b><font color=Blue> Deployed version of SALT : </b></font> <b><font color=Red>$deploymentVersionName</b></font> <br>"
$Body += "<b><font color=Blue> Branch Name : </b></font> <b><font color=Red>$SaltAutomationBranch</b></font> <br>"
$Body += "<b><font color=Blue> Execution Environment : </b></font> <b><font color=red>$ExecutionEnvironment</b></font> <br>"
$Body += "<b><font color=Blue> CategoriesExecuted : </b></font> <b><font color=red>$CategoriesExecuted</b></font> <br>"

$SMTPServer = "GB-PB-SMTP-V01.emea.travelex.net"
$SMTPPort = "25"
Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -port $SMTPPort -Attachments $attachmentPath –DeliveryNotificationOption OnSuccess