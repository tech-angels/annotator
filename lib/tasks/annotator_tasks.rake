desc "Explaining what the task does"
task :annotate => :environment do
  Annotator.run
end
