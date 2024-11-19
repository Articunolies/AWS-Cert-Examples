require 'aws-sdk-s3'
require 'pry'
require 'securerandom'

bucket_name = ENV['BUCKET_NAME']
region = 'us-west-1'

client = Aws::S3::Client.new

resp = client.create_bucket({
    bucket: bucket_name,
    create_bucket_configuration: {
        location_constraint: region
    }
})

number_of_files = 1+rand(6)

puts "number of files: #{number_of_files}"

number_of_files.times.each do |i|
    puts "i: #{i}"
    file_name = "file_#{i}.txt"
    output_path = "/tmp/#{file_name}"

    File.open(output_path, 'w') do |file|
        file.write(SecureRandom.uuid)
    end

    File.open(output_path, 'rb') do |file|
        client.put_object(
            bucket: bucket_name, 
            key: file_name, 
            body: file
        )
    end
end


