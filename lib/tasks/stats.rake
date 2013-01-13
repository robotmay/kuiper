namespace :kuiper do
  namespace :stats do
    task :ensure_online_visitor_counts_workers_running => :environment do
      Site.find_each do |site|
        scheduler = Sidekiq::ScheduledSet.new
        jobs = scheduler.select do |job|
          job.klass == "OnlineVisitorsCountWorker" && job.args[0] == site.id
        end

        case
        when jobs.count == 0
          OnlineVisitorsCountWorker.perform_async(site.id)
        when jobs.count > 1
          keep = jobs.shift
          jobs.each(&:destroy)
        end
      end
    end
  end

  namespace :testing do
    desc "Generate statistics in an infinite loop"
    task :generate_stats => :environment do
      site_api_key = ENV['api_key']

      site = Site.find_by_api_key(site_api_key)
      if site.nil?
        $stdout.puts "No site specified"
        return
      end

      host = site.allowed_hosts.first
      url = "http://#{host}"

      loop do
        visitor_id = SecureRandom.uuid
        cookies = [true, false].sample
        java = [true, false].sample
        user_agent = [
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:18.0) Gecko/20100101 Firefox/18.0",
          "Mozilla/5.0 (Windows NT 6.1; rv:18.0) Gecko/20100101 Firefox/18.0",
          "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97 Safari/537.11"
        ].sample
        screen = {
          width: 1920,
          height: 1080,
          colour_depth: [16,32].sample,
          available_width: 1920,
          available_height: 980
        }
        
        (1..10).to_a.sample.times do |i|
          previous_visit ||= nil
          previous_page ||= nil
          timestamp = Time.now.to_f
          page = "an-interesting-article-#{i}"
          uri = URI.join(url, page).to_s

          visit = site.visits.create_from_client_data(
            api_key: site.api_key,
            timestamp: timestamp,
            ip_address: "127.0.0.1",
            country_code: "GB",
            visitor_id: visitor_id,
            previous_visit: previous_visit,
            previous_page: previous_page,
            browser: {
              user_agent: user_agent,
              cookies_enabled: cookies,
              java_enabled: java,
              plugins: [],
            },
            system: {
              screen: screen
            },
            browser: {
              inner_width: screen[:width],
              inner_height: screen[:height] - 300
            },
            page: {
              url: uri,
              referrer: nil,
              title: "A Test Page #{i}",
              last_modified: (1..100).to_a.sample.days.ago
            }
          )

          $stdout.puts "Created: #{visit.inspect}"

          previous_visit = timestamp
          previous_page = uri

          sleep (1..5).to_a.sample
        end
        
        sleep (1..20).to_a.sample
        break
      end
    end
  end
end
