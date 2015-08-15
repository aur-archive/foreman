SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

RAILS_ENV=production
FOREMAN_HOME=/usr/share/foreman

# Clean up the session entries in the database
15 23 * * *     foreman    cd ${FOREMAN_HOME} && /opt/ruby1.9/lib/ruby/gems/1.9.1/bin/bundle exec rake db:sessions:clear

# Send out daily summary
0 7 * * *       foreman    cd ${FOREMAN_HOME} && /opt/ruby1.9/lib/ruby/gems/1.9.1/bin/bundle exec rake reports:summarize

# Expire old reports
30 7 * * *      foreman    cd ${FOREMAN_HOME} && /opt/ruby1.9/lib/ruby/gems/1.9.1/bin/bundle exec rake reports:expire

# Collects trends data
*/30 * * * *    foreman    cd ${FOREMAN_HOME} && /opt/ruby1.9/lib/ruby/gems/1.9.1/bin/bundle exec rake trends:counter


# Only use the following cronjob if you're using stored configs!
# Populate hosts
*/30 * * * *    foreman    cd ${FOREMAN_HOME} && /opt/ruby1.9/lib/ruby/gems/1.9.1/bin/bundle exec rake puppet:migrate:populate_hosts


# Only uncomment the following cronjob if you're not using stored configs!
# Send facts to Foreman.
#*/2 * * * *    puppet     ${FOREMAN_HOME}/extras/puppet/foreman/files/push_facts.rb
