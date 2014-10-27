# Evolving Web extensions to redmine

This contains misc glue code to customize our Redmine deployment.


## {{id}} macro

Currently contains {{id}} macro which is an alias for {{issue_details}}.
The latter is provided by [https://github.com/hampom/redmine_wiki_issue_details](https://github.com/hampom/redmine_wiki_issue_details)

## "My Timesheet" link

Adds a "My Timesheet" link to the main menu. Links to the following:

`/time_entries/report?utf8=✓&criteria[]=user&criteria[]=project&criteria[]=issue&f[]=spent_on&op[spent_on]=><t-&v[spent_on][]=7&f[]=&c[]=project&c[]=spent_on&c[]=user&c[]=activity&c[]=issue&c[]=comments&c[]=hours&columns=day`
