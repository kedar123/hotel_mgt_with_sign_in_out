namespace :my_namespace do
  desc "TODO"
  task :import_reservation_from_gds => :environment do
    #here the task should be of importing the reservations
     Getbooking.rake_task_booking
  end

end
