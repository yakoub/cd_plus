# cd_plus, bash cd bookmarks
fast directory browsing using bookmarks .

## quick example
(source cd_plus.sh to get function cd+)  
```bash
cd /srv/company_x/drupal/
# initialize
cd+ -init
cd sites/project1/modules/guides_migrations
# bookmark this location
cd+ -book
# jump to root by pattern matching
cd+ -dir y_x.*al
cd core/lib/Drupal/Core
cd+ -book
# jump back to root using simpler pattern
cd+ -dir pal
cd core/modules/migrate/src/Plugin/migrate
cd+ -book
# jump to guides_migrations
cd+ t1.*ions
# list bookmarks
cd+ -list
/sites/project1/modules/guides_migrations
/core/lib/Drupal/Core
/core/modules/migrate/src/Plugin/migrate
# list managed directories
cd+ -dir
/srv/company_x/drupal
/srv/company_x/django
/srv/company_y/django
/home/yakoub/docs
# jump directory to company_y/django
cd+ -dir y.*go
```
