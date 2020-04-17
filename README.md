"# ch-aviation-automation" 

Install https://www.microsoft.com/en-us/download/confirmation.aspx?id=13255

Install Strawberry

Create CHAviation ODCBInst DSN

cpan install Parse::CSV

cpan install DBD::CSV


EDIT 
Variables in config_win.yaml
DSN : "CHaviation"
month: "month1" or "month2"

EXECUTE
perl ./taskrunner_win.pl

