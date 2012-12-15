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
end
