# Evolving Web extensions to redmine

This contains misc glue code to customize our Redmine deployment.


## {{id}} macro

Currently contains {{id}} macro which is an alias for {{issue_details}}.
The latter is provided by [https://github.com/hampom/redmine_wiki_issue_details](https://github.com/hampom/redmine_wiki_issue_details)

## "My Timesheet" link

Adds a "My Timesheet" link to the main menu. Links to the following:

`/time_entries/report?utf8=✓&criteria[]=user&criteria[]=project&criteria[]=issue&f[]=spent_on&op[spent_on]=><t-&v[spent_on][]=7&f[]=&c[]=project&c[]=spent_on&c[]=user&c[]=activity&c[]=issue&c[]=comments&c[]=hours&columns=day`

## Homepage redirect

When visiting `http://redmine-url.com`, the visitor is redirected to `http://redmine-url.com/my/page`.

## Subtask Clone link

Adds a "Clone" link next to the Subtask tree's "Add" link, which works the same but copies all metatada.
Only on issue pages.

## Links in timesheet reports

Issues in timesheet reports are now clickable links.


## Broken issue description text area

The upgraded plugin `redmine_wiki_extensions` breaks the layout issue. This small CSS fixes that.

## Date range on hover for weekly reports

Adds a title attribute to be shown on hover for the columns on a weekly spent time report.
