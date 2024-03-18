$xml=@"
<?xml version="1.0" encoding="utf-8"?>
<PunchhConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <LogLevel>6</LogLevel>
  <PrintBarcodes>1</PrintBarcodes>
  <ShortKey>ENTER STUFF HERE</ShortKey>
  <Diagnostics>0</Diagnostics>
  <Header />
  <Trailer1 />
  <Trailer2 />
  <Trailer3 />
  <Trailer4 />
  <Trailer5 />
  <UpdateInterval>60</UpdateInterval>
</PunchhConfiguration>
"@

$txt=@"
PunchhDiscountObjectNumber=ENTER STUFF HERE
PunchhIntendedDiscountObjectNumber=ENTER STUFF HERE
PropertyLocationKey[ENTER STUFF HERE]=ENTER STUFF HERE
"@

$xml > C:\Micros\Simphony\WebServer\wwwroot\EGateway\Handlers\ExtensionApplications\PunchhInterface\PunchhConfig.xml
$txt > C:\Micros\Simphony\WebServer\wwwroot\EGateway\Handlers\ExtensionApplications\PunchhInterface\PunchhSettings.txt