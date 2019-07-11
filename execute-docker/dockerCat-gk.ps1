[CmdletBinding(PositionalBinding = $False)]
Param
(
	[parameter(Mandatory = $True)] [String]$pathToDockerComposeFile,
	[parameter(Mandatory = $True)] [string]$allCategories
)

echo $pwd

#$allCategories = "DidYouKnow Promotions6"
#$pathToDockerComposeFile = "C:\SALT_Automation\References"

$newCategories = $allCategories.Split(" ")
$argcount = $newCategories.Length
#$spaceCat = ""



  Write-Output "categoy is: $newCategories"

foreach( $arg in $newCategories ) 
{

       Write-Output "arg is: $arg"

    if( $arg -like "*,*" ) 
    {
        $spaceCat = $arg -replace(","," ")
    }
    else
    {
       $spaceCat = $arg
    }
  
  $spaceCat = $spaceCat.Trim()
    Write-Output "Up Start time: $(Get-Date)"

	Write-Output $spaceCat hello
   $spaceCat = $spaceCat.Split(" ")
   $dockerexec = "C:\Program Files\Docker\docker-compose.exe"
  cd $pathToDockerComposeFile
   "$dockerexec up $spaceCat"
   $execeution =& $dockerexec up $spaceCat
   
   $execeutiondown =& $dockerexec down

}



