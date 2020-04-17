"# ch-aviation-automation" 

Install https://www.microsoft.com/en-us/download/confirmation.aspx?id=13255

Install Strawberry - http://strawberryperl.com/

Create CHAviation ODCBInst DSN - https://support.office.com/en-us/article/administer-odbc-data-sources-b19f856b-5b9b-48c9-8b93-07484bfab5a7

cpan install Parse::CSV

cpan install DBD::CSV


EDIT 
Variables in config_win.yaml
DSN : "CHaviation"
month: "month1" or "month2"

EXECUTE
perl ./taskrunner_win.pl

